//
//  boardViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 6/5/18.
//  Copyright © 2018 Tareq El Dandachi. All rights reserved.
//

import UIKit

import AVFoundation

import CoreImage

class boardViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    /*@IBOutlet weak var previewView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detect() {
        let imageOptions =  NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
        let personciImage = CIImage(CGImage: imagePicker.image!.CGImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector.featuresInImage(personciImage, options: imageOptions as? [String : AnyObject])
        
        if let face = faces.first as? CIFaceFeature {
            print("found bounds are \(face.bounds)")
            
            let alert = UIAlertController(title: "Say Cheese!", message: "We detected a face!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            if face.hasSmile {
                print("face is smiling");
            }
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        } else {
            let alert = UIAlertController(title: "No Face!", message: "No face was detected", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        self.detect()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }*/
    
    @IBOutlet var qrDecodeLabel: UILabel!
    @IBOutlet var detectorModeSelector: UISegmentedControl!
    
    var videoFilter: CoreImageVideoFilter?
    var detector: CIDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create the video filter
        videoFilter = CoreImageVideoFilter(superview: view, applyFilterCallback: nil)
        
        // Simulate a tap on the mode selector to start the process
        detectorModeSelector.selectedSegmentIndex = 0
        handleDetectorSelectionChange(detectorModeSelector)
    }
    
    @IBAction func handleDetectorSelectionChange(_ sender: UISegmentedControl) {
        if let videoFilter = videoFilter {
            videoFilter.stopFiltering()
            self.qrDecodeLabel.isHidden = true
            
            switch sender.selectedSegmentIndex {
            case 0:
                detector = prepareRectangleDetector()
                videoFilter.applyFilter = {
                    image in
                    
                    return self.performRectangleDetection(image)
                }
            case 1:
                detector = prepareRectangleDetector()
                videoFilter.applyFilter = {
                    image in
                    
                    return self.cropAndDetect(image)
                }
            case 2:
                self.qrDecodeLabel.isHidden = false
                detector = prepareQRCodeDetector()
                videoFilter.applyFilter = {
                    image in
                    let found = self.performQRCodeDetection(image)
                    DispatchQueue.main.async {
                        if found.decode != "" {
                            self.qrDecodeLabel.text = found.decode
                        }
                    }
                    return found.outImage
                }
            default:
                videoFilter.applyFilter = nil
            }
            
            videoFilter.startFiltering()
        }
    }
    
    
    //MARK: Utility methods
    func performRectangleDetection(_ image: CIImage) -> CIImage? {
        var resultImage: CIImage?
        if let detector = detector {
            // Get the detections
            let features = detector.features(in: image)
            for feature in features as! [CIRectangleFeature] {
                
                print(feature.topLeft, feature.topRight, feature.bottomLeft, feature.bottomLeft)
                
                resultImage = drawHighlightOverlayForPoints(image, topLeft: feature.topLeft, topRight: feature.topRight,
                                                            bottomLeft: feature.bottomLeft, bottomRight: feature.bottomRight)
            }
        }
        return resultImage
    }
    func cropAndDetect(_ image: CIImage) -> CIImage? {
        var resultImage: CIImage?
        if let detector = detector {
            // Get the detections
            let features = detector.features(in: image)
            for feature in features as! [CIRectangleFeature] {
                
                print(feature.topLeft, feature.topRight, feature.bottomLeft, feature.bottomLeft)
                
                resultImage = cropBoard(image, topLeft: feature.topLeft, topRight: feature.topRight,
                                        bottomLeft: feature.bottomLeft, bottomRight: feature.bottomRight)
            }
        }
        return resultImage
    }
    
    func performQRCodeDetection(_ image: CIImage) -> (outImage: CIImage?, decode: String) {
        var resultImage: CIImage?
        var decode = ""
        if let detector = detector {
            let features = detector.features(in: image)
            for feature in features as! [CIQRCodeFeature] {
                resultImage = drawHighlightOverlayForPoints(image, topLeft: feature.topLeft, topRight: feature.topRight,
                                                            bottomLeft: feature.bottomLeft, bottomRight: feature.bottomRight)
                decode = feature.messageString!
            }
        }
        return (resultImage, decode)
    }
    
    func prepareRectangleDetector() -> CIDetector {
        print("prepareRectangleDetector")
        let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyLow, CIDetectorAspectRatio: 1/1.41]
        return CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: options)!
    }
    
    func prepareQRCodeDetector() -> CIDetector {
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        return CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)!
    }
    
    func drawHighlightOverlayForPoints(_ image: CIImage, topLeft: CGPoint, topRight: CGPoint,
                                       bottomLeft: CGPoint, bottomRight: CGPoint) -> CIImage {
        var overlay = CIImage(color: CIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5))
        overlay = overlay.cropped(to: image.extent)
        overlay = overlay.applyingFilter("CIPerspectiveTransformWithExtent",
                                         parameters: [
                                            "inputExtent": CIVector(cgRect: image.extent),
                                            "inputTopLeft": CIVector(cgPoint: topLeft),
                                            "inputTopRight": CIVector(cgPoint: topRight),
                                            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
                                            "inputBottomRight": CIVector(cgPoint: bottomRight)
            ])
        return overlay.composited(over: image)
    }
    
    func cropBoard(_ image: CIImage, topLeft: CGPoint, topRight: CGPoint,
                                       bottomLeft: CGPoint, bottomRight: CGPoint) -> CIImage {
        var rectCoords = NSMutableDictionary(capacity: 4)
        rectCoords["inputTopLeft"] = CIVector(cgPoint:topLeft)
        rectCoords["inputTopRight"] = CIVector(cgPoint:topRight)
        rectCoords["inputBottomLeft"] = CIVector(cgPoint:bottomLeft)
        rectCoords["inputBottomRight"] = CIVector(cgPoint:bottomRight)
        return image.applyingFilter("CIPerspectiveCorrection", parameters: rectCoords as! [String : Any])

    }
    
}
