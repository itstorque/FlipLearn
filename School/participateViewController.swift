//
//  participateViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 5/12/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.
//

import UIKit

import AVFoundation

import CoreImage

class participateViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var guidanceLabel: UILabel!
    
    @IBOutlet weak var captureButton: UIButton!
    
    var captureSession: AVCaptureSession!
    
    var stillImageOutput: AVCaptureStillImageOutput?
    
    //var previewLayer: AVCaptureVideoPreviewLayer?
    
    var featureGlobal = ""
    
    //var captureSession:AVCaptureSession?
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    let supportedBarCodes = [AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("ON")
        
        guidanceLabel.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 20)
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        videoPreviewLayer?.frame = view.frame
        
        view.layer.addSublayer(videoPreviewLayer!)
        
        if let connection =  self.videoPreviewLayer?.connection  {
            
            let previewLayerConnection : AVCaptureConnection = connection
            
            switch UIDevice.current.orientation{
                
            case .landscapeRight:
                
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                
            default:
                
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                
            }
            
        }
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        breakQuizData(str: code)
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        
        layer.videoOrientation = orientation
        
        videoPreviewLayer?.frame = self.view.bounds
        
    }
    
    @objc func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            
            //qrCodeFrameView?.frame = CGRect.zero
            
            return
            
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedBarCodes.contains(metadataObj.type) {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            
            //qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                breakQuizData(str: metadataObj.stringValue!)
                
            }
            
        }
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        if let connection =  self.videoPreviewLayer?.connection  {
            
            let previewLayerConnection : AVCaptureConnection = connection
            
            switch UIDevice.current.orientation{
                
            case .landscapeLeft:
                
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                
            default:
                
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                
            }
            
        }
        
    }
    
    func checkForQR() {
        
        print("LOOKING")
        
        if featureGlobal == "" {
            
            guidanceLabel.text = "Repeat!"
            
        } else {
            
            print(featureGlobal)
            
            guidanceLabel.text = "DONE! 😃"
            
            previewView.isHidden = true
            
            captureButton.isHidden = true
            
            breakQuizData(str: featureGlobal)
            
        }
        
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var error: NSError?
        
        var input: AVCaptureDeviceInput!
        
        do {
            
            input = try AVCaptureDeviceInput(device: backCamera)
            
        } catch let error1 as NSError {
            
            error = error1
            
            input = nil
            
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if captureSession!.canAddOutput(stillImageOutput) {
                
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                
                /*previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                
                if UIDevice.current.orientation == .landscapeLeft {
                    
                    previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                    
                } else {
                    
                    previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                    
                }*/
                
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
                
            }
            
        }
        
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //previewLayer!.frame = previewView.bounds
        
    }
    
    func processQR() {
        
        if let videoConnection = stillImageOutput!.connection(with: AVMediaType.video) {
            
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                
                if (sampleBuffer != nil) {
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    
                    let detector : CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
                    
                    let ciImage = CIImage(cgImage: cgImageRef!)
                    
                    let features = detector.features(in: ciImage)
                    
                    print(features)
                    
                    if features.count > 0 {
                        
                        print("Found " + String(features.count) + " QR Codes")
                        
                        for feature in features as! [CIQRCodeFeature] {
                            
                            print(feature.messageString!)
                            
                            self.featureGlobal = feature.messageString!
                            
                            self.checkForQR()
                            
                        }
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    var questions : [String] = []
    
    var answers = [[""]]
    
    var correctAnswer : [Int] = []
    
    var quizData : String = "NAME(#)ID"
    
    var timeLimit = -1
    
    var type = -1
    
    var hasCalc = false
    
    func breakQuizData(str: String) {
        
        videoPreviewLayer?.isHidden = true
        
        answers = []
        
        questions = []
        
        quizData = "NAME(#)ID"
        
        correctAnswer = []
        
        timeLimit = -1
        
        type = -1
        
        hasCalc = false
        
        print("\n\n\nGRABBED DATA\n\n\n")
        
        /// Mr. Dandachi^&^96582548^{-1,2,0}^&^*<init>*q1:what is 1+1^&^[]^&^[2]*<done>*
        
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "notes")
        
        self.present(vc, animated: false, completion: nil)*/
        
        quizData = String(str.components(separatedBy: "^{")[0]).replacingOccurrences(of: "^&^", with: "-")
        
        let arrayData = String(str.components(separatedBy: "^{")[1].components(separatedBy: "}^&^")[0]).components(separatedBy: ",")
        
        timeLimit = Int(arrayData[0])!
        
        type = Int(arrayData[1])!
        
        if Int(arrayData[2])! == 1 {
            
            hasCalc = true
            
        }
        
        print(quizData)
        
        print(timeLimit, type, hasCalc)
        
        let qData = String(str.components(separatedBy: "*<init>*")[1].components(separatedBy: "*<done>*")[0]).components(separatedBy: ";&*;")
        
        for question in qData {
            
            questions.insert(question.components(separatedBy: "^&^")[0], at: 0)
            
            let dA = String(String(question.components(separatedBy: "^&^")[1].dropFirst()).dropLast()).components(separatedBy: ",")
            
            answers.insert(dA, at: 0)
            
            var v = question.components(separatedBy: "^&^")[2]
            
            print(v)
            
            v = String(String(v.dropLast()).dropFirst())
            
            print(v)
            
            correctAnswer.insert(Int(v)!, at: 0)
            
        }
        
        unlockCode = str.components(separatedBy: "*<done>*")[1]
        
        print("Q" + String(describing: questions))
        
        print("A" + String(describing: answers))
        
        print("C" + String(describing: correctAnswer))
        
        if type == 0 {
            
            initBooleanQuiz()
            
        } else if type == 1 {
            
            initMCQuiz()
            
        } else if type == 2 {
            
            initNQuiz()
            
        }
        
    }
    
    let quizView = UIView(frame: CGRect.null)
    
    let questionLabel = correctAlignmentLabel(frame: CGRect.null)
    
    let questionView = UIView(frame: CGRect.null)
    
    let ansField = UITextField(frame: CGRect.null)
    
    let button1 = UIButton(frame: CGRect.null)
    
    let button2 = UIButton(frame: CGRect.null)
    
    let button3 = UIButton(frame: CGRect.null)
    
    let button4 = UIButton(frame: CGRect.null)
    
    let status = UILabel(frame: CGRect.null)
    
    var qIndex = -1
    
    var correctionArray : [Bool] = []
    
    var run = false
    
    //True or False
    
    var qNumber = 1
    
    func initBooleanQuiz() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        guidanceLabel.text = "Question Number " + String(qNumber)
        
        guidanceLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        guidanceLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        qIndex = questions.count - 1
        
        quizView.frame = view.frame
        
        view.addSubview(quizView)
        
        questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        questionLabel.textAlignment = .center
        
        questionView.frame = CGRect(x: view.frame.width / 5, y: 0, width: 3 * view.frame.width / 5, height: view.frame.height)
        
        questionLabel.frame = CGRect(x: 0, y: 250, width: questionView.frame.width, height: 100)
        
        questionLabel.numberOfLines = 5
        
        questionLabel.textColor = UIColor.black
        
        let MoveCard = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        
        questionView.backgroundColor = UIColor.white
        
        status.frame = CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50)
        
        status.backgroundColor = UIColor.white
        
        status.textColor = UIColor.black
        
        status.font = UIFont.systemFont(ofSize: 17)
        
        if timeLimit == -1 {
            
            status.text = "time left: ∞"
            
        } else {
            
            status.text = "time left: \(timeLimit)"
            
        }
        
        status.textAlignment = .center
        
        questionLabel.text = questions[qIndex]
        
        button1.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        button1.layer.cornerRadius = 0
        
        button1.setImage(#imageLiteral(resourceName: "tick"), for: [])
        
        button1.frame = CGRect(x: 4 * view.frame.width / 5, y: 0, width: view.frame.width / 5, height: view.frame.height)
        
        button1.addTarget(self, action: #selector(self.checkIfAnsIsTruePress), for: .touchUpInside)
        
        button2.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        button2.layer.cornerRadius = 0
        
        button2.setImage(#imageLiteral(resourceName: "cross"), for: [])
        
        button2.addTarget(self, action: #selector(self.checkIfAnsIsFalsePress), for: .touchUpInside)
        
        button2.frame = CGRect(x: 0, y: 0, width: view.frame.width / 5, height: view.frame.height)
        
        quizView.addSubview(button1)
        
        quizView.addSubview(button2)
        
        quizView.addSubview(status)
        
        quizView.addSubview(questionView)
        
        //guidanceLabel.removeFromSuperview()
        
        quizView.addSubview(status)
        
        button1.imageView?.alpha = 0.5
        
        button2.imageView?.alpha = 0.5
        
        questionView.center = view.center
        
        questionView.isUserInteractionEnabled = true
        
        questionView.addGestureRecognizer(MoveCard)
        
        questionView.addSubview(questionLabel)
        
        guidanceLabel.frame = CGRect(x: 0, y: 100, width: questionView.frame.width, height: 100)
        
        questionView.addSubview(guidanceLabel)
        
        print(qIndex)
        
        if run == false {
            
            timePassForBool()
            
            run = true
        }
        
    }
    
    let minXToPerformAction : CGFloat = 100
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        
        questionView.center = CGPoint(x:questionView.center.x + translation.x, y:questionView.center.y)
        
        button2.frame = CGRect(x:button2.frame.origin.x,y:button2.frame.origin.y,width:button2.frame.width + translation.x,height:button2.frame.height)
        
        button1.frame = CGRect(x:button1.frame.origin.x + translation.x,y:button1.frame.origin.y,width:button1.frame.width - translation.x,height:button1.frame.height)
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        if view.center.x - questionView.center.x < -minXToPerformAction {
            
            button2.imageView?.alpha = 1
            
            button1.imageView?.alpha = 0.5
            
        } else if view.center.x - questionView.center.x > minXToPerformAction {
            
            button1.imageView?.alpha = 1
            
            button2.imageView?.alpha = 0.5
            
        } else {
            
            button1.imageView?.alpha = 0.5
            
            button2.imageView?.alpha = 0.5
            
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {
            
            button1.imageView?.alpha = 0.5
            
            button2.imageView?.alpha = 0.5
            
            if view.center.x - questionView.center.x < -minXToPerformAction {
                
                checkIfAnsIsFalse()
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    //self.questionView.transform = CGAffineTransform(rotationAngle: 0)
                    
                    self.questionView.frame = CGRect(x:self.questionView.frame.origin.x + 500,y:self.questionView.frame.origin.y,width:self.questionView.frame.width,height:self.questionView.frame.height)
                    
                    self.button2.frame = CGRect(x:self.button2.frame.origin.x,y:self.button2.frame.origin.y,width:self.button2.frame.width + 500,height:self.button2.frame.height)
                    
                })
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.questionView.center = self.view.center
                    
                    self.button1.frame = CGRect(x: 4 * self.view.frame.width / 5, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
                    
                    self.button2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
                    
                    self.questionView.center = self.view.center
                    
                })
                
            } else if view.center.x - questionView.center.x > minXToPerformAction {
                
                checkIfAnsIsTrue()
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    //self.questionView.transform = CGAffineTransform(rotationAngle: 0)
                    
                    self.questionView.frame = CGRect(x:self.questionView.frame.origin.x - 500,y:self.questionView.frame.origin.y,width:self.questionView.frame.width,height:self.questionView.frame.height)
                    
                    self.button1.frame = CGRect(x:self.button1.frame.origin.x - 500,y:self.button1.frame.origin.y,width:self.button1.frame.width + 500,height:self.button1.frame.height)
                    
                })
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.questionView.center = self.view.center
                    
                    self.button1.frame = CGRect(x: 4 * self.view.frame.width / 5, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
                    
                    self.button2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
                    
                    self.questionView.center = self.view.center
                    
                })
            
            } else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    //self.questionView.transform = CGAffineTransform(rotationAngle: 0)
                    
                    self.questionView.center = self.view.center
                    
                })
                
            }
            
        }
        
        //let Angle = -( view.center.x - questionView.center.x ) / 360
        
        /*if view.center.x - questionView.center.x > minXToPerformAction {
            
            questionView.backgroundColor = TheBlue
            
            front.textColor = UIColor.white
            
        } else if view.center.x - questionView.center.x < -minXToPerformAction{
            
            questionView.backgroundColor = TheBlue
            
            front.textColor = UIColor.white
            
        } else {
            
            questionView.backgroundColor = TheOffWhite
            
            front.textColor = TheBlue
            
        }*/
        
        //questionView.transform = CGAffineTransform(rotationAngle: Angle)
        
    }
    
    @objc func checkIfAnsIsTruePress() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            //self.questionView.transform = CGAffineTransform(rotationAngle: 0)
            
            self.questionView.frame = CGRect(x:self.questionView.frame.origin.x - 500, y: self.questionView.frame.origin.y, width: self.questionView.frame.width, height: self.questionView.frame.height)
            
            self.button1.frame = CGRect(x:self.button1.frame.origin.x - 500, y: self.button1.frame.origin.y, width: self.button1.frame.width + 500, height: self.button1.frame.height)
            
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.questionView.center = self.view.center
            
            self.button1.frame = CGRect(x: 4 * self.view.frame.width / 5, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
            
            self.button2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
            
            self.questionView.center = self.view.center
            
        })
        
        checkIfAnsIsTrue()
        
    }
    
    @objc func checkIfAnsIsFalsePress() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            //self.questionView.transform = CGAffineTransform(rotationAngle: 0)
            
            self.questionView.frame = CGRect(x:self.questionView.frame.origin.x + 500,y:self.questionView.frame.origin.y,width:self.questionView.frame.width,height:self.questionView.frame.height)
            
            self.button2.frame = CGRect(x:self.button2.frame.origin.x,y:self.button2.frame.origin.y,width:self.button2.frame.width + 500,height:self.button2.frame.height)
            
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.questionView.center = self.view.center
            
            self.button1.frame = CGRect(x: 4 * self.view.frame.width / 5, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
            
            self.button2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 5, height: self.view.frame.height)
            
            self.questionView.center = self.view.center
            
        })
        
        checkIfAnsIsFalse()
        
    }
    
    func checkIfAnsIsTrue() {
        
        print(qIndex)
        
        if correctAnswer[qIndex] == 1 {
            
            correctionArray.insert(true, at: 0)
            
        } else {
            
            correctionArray.insert(false, at: 0)
            
        }
        
        updateBooleanQuestion()
        
    }
    
    func checkIfAnsIsFalse() {
        
        print(qIndex)
        
        if correctAnswer[qIndex] == 0 {
            
            correctionArray.insert(true, at: 0)
            
        } else {
            
            correctionArray.insert(false, at: 0)
            
        }
        
        updateBooleanQuestion()
        
    }
    
    func updateBooleanQuestion() {
        
        if timeLimit == -1 {
            
            status.text = "time left: ∞"
            
        } else {
            
            status.text = "time left: \(timeLimit)"
            
        }
        
        status.textColor = UIColor.black
        
        status.font = UIFont.systemFont(ofSize: 17)
        
        qNumber = qNumber + 1
        
        guidanceLabel.text = "Question Number " + String(qNumber)
        
        qIndex = qIndex - 1
        
        button1.imageView?.alpha = 0.5
        
        button2.imageView?.alpha = 0.5
        
        if qIndex > -1 {
            
            questionLabel.text = questions[qIndex]
            
        } else {
            
            status.text = "time left: ∞"
            
            correct = 0
            
            for item in correctionArray {
                
                if item == true {
                    
                    correct = correct + 1
                    
                }
                
            }
            
            guidanceLabel.text = "You're Done!"
            
            questionLabel.text = "You scored a " + String(correct) + "/" + String(correctionArray.count)
            
            button1.isHidden = true
            
            button2.isHidden = true
            
            createQR()
            
        }
        
    }
    
    @objc func timePassForBool() {
        
        if !(status.text == "time left: ∞") {
            
            if status.text == "time left: 0" {
                
                correctionArray.insert(false, at: 0)
                
                updateBooleanQuestion()
                
                print("EX")
                
            } else {
                
                let n = Int(String(status.text!.dropFirst(11)))
                
                print(String(status.text!.dropFirst(11)))
                
                status.text = "time left: " + String(n! - 1)
                
                _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timePassForBool), userInfo: [], repeats: false)
                
                print("INIT")
                
            }
            
            if status.text == "time left: 5" {
                
                status.font = UIFont.boldSystemFont(ofSize: 17)
                
                status.textColor = UIColor.red
                
                print("LOW")
                
            }
            
        }
        
    }
    
    //MCQ
    
    var A = UILabel(frame: CGRect.null)
    
    var B = UILabel(frame: CGRect.null)
    
    var C = UILabel(frame: CGRect.null)
    
    var D = UILabel(frame: CGRect.null)
    
    let optionA = UILabel(frame: CGRect.null)
    
    let optionB = UILabel(frame: CGRect.null)
    
    let optionC = UILabel(frame: CGRect.null)
    
    let optionD = UILabel(frame: CGRect.null)
    
    let tickPhoto = UIImageView(image: #imageLiteral(resourceName: "tick"))
    
    func initMCQuiz() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        quizView.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.9450980392, blue: 0.9960784314, alpha: 1)
        
        let bg = UILabel(frame: CGRect(x: 5, y: 20, width: view.frame.width / 4, height: view.frame.height - 90))
        
        bg.backgroundColor = UIColor.white
        
        guidanceLabel.text = "Question Number " + String(qNumber)
        
        guidanceLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.black)
        
        guidanceLabel.textColor = UIColor.black

        guidanceLabel.frame = CGRect(x: 5, y: 50, width: view.frame.width / 4, height: 50)
        
        status.frame = CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50)
        
        status.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.9450980392, blue: 0.9960784314, alpha: 1)
        
        status.textColor = UIColor.black
        
        status.font = UIFont.systemFont(ofSize: 17)
        
        if timeLimit == -1 {
            
            status.text = "time left: ∞"
            
        } else {
            
            status.text = "time left: \(timeLimit)"
            
        }
        
        status.textAlignment = .center
        
        qIndex = questions.count - 1
        
        quizView.frame = view.frame
        
        view.addSubview(quizView)
        
        questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        questionLabel.frame = CGRect(x: 5, y: 150, width: view.frame.width / 4, height: view.frame.height - 190)
        
        questionLabel.text = questions[qIndex]
        
        questionLabel.numberOfLines = 10
        
        button1.titleLabel?.textColor = UIColor.black
        
        button1.backgroundColor = UIColor.white
        
        optionA.text = answers[qIndex][0]
        
        button1.frame = CGRect(x: view.frame.width / 4 + 25, y: 20, width: 3 * view.frame.width / 4 - 50, height: bg.frame.height / 4)
        
        button1.addTarget(self, action: #selector(self.checkIfAnsIs1), for: .touchUpInside)
        
        button2.backgroundColor = UIColor.white
        
        optionB.text = answers[qIndex][1]
        
        button2.addTarget(self, action: #selector(self.checkIfAnsIs2), for: .touchUpInside)
        
        button2.frame = CGRect(x: view.frame.width / 4 + 25, y: 20 + bg.frame.height / 4, width: 3 * view.frame.width / 4 - 50, height: bg.frame.height / 4)
        
        button3.backgroundColor = UIColor.white
        
        optionC.text = answers[qIndex][2]
        
        button3.addTarget(self, action: #selector(self.checkIfAnsIs3), for: .touchUpInside)
        
        button3.frame = CGRect(x: view.frame.width / 4 + 25, y: 20 + 2 * bg.frame.height / 4, width: 3 * view.frame.width / 4 - 50, height: bg.frame.height / 4)
        
        button4.backgroundColor = UIColor.white
        
        optionD.text = answers[qIndex][3]
        
        button4.addTarget(self, action: #selector(self.checkIfAnsIs4), for: .touchUpInside)
        
        button4.frame = CGRect(x: view.frame.width / 4 + 25, y: 20 + 3 * bg.frame.height / 4, width: 3 * view.frame.width / 4 - 50, height: bg.frame.height / 4)
        
        A = UILabel(frame: CGRect(x: button1.frame.origin.x, y: button1.frame.origin.y, width: button1.frame.height, height: button1.frame.height))
        
        B = UILabel(frame: CGRect(x: button2.frame.origin.x, y: button2.frame.origin.y, width: button2.frame.height, height: button2.frame.height))
        
        C = UILabel(frame: CGRect(x: button3.frame.origin.x, y: button3.frame.origin.y, width: button3.frame.height, height: button3.frame.height))
        
        D = UILabel(frame: CGRect(x: button4.frame.origin.x, y: button4.frame.origin.y, width: button4.frame.height, height: button4.frame.height))
        
        optionA.frame = CGRect(x: A.frame.origin.x + A.frame.width, y: A.frame.origin.y, width: button1.frame.width - A.frame.width, height: A.frame.height)
        
        optionB.frame = CGRect(x: B.frame.origin.x + B.frame.width, y: B.frame.origin.y, width: button2.frame.width - B.frame.width, height: B.frame.height)
        
        optionC.frame = CGRect(x: C.frame.origin.x + C.frame.width, y: C.frame.origin.y, width: button3.frame.width - C.frame.width, height: C.frame.height)
        
        optionD.frame = CGRect(x: D.frame.origin.x + D.frame.width, y: D.frame.origin.y, width: button4.frame.width - D.frame.width, height: D.frame.height)
        
        A.text = "A"
        
        B.text = "B"
        
        C.text = "C"
        
        D.text = "D"
        
        A.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        B.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        C.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        D.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        A.textAlignment = .center
        
        B.textAlignment = .center
        
        C.textAlignment = .center
        
        D.textAlignment = .center
        
        A.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.black)
        
        B.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.black)
        
        C.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.black)
        
        D.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.black)
        
        button4.backgroundColor = UIColor.white
        
        button2.backgroundColor = UIColor.white
        
        button3.backgroundColor = UIColor.white
        
        button1.backgroundColor = UIColor.white
        
        optionA.font = UIFont.systemFont(ofSize: 22)
        
        optionB.font = UIFont.systemFont(ofSize: 22)
        
        optionC.font = UIFont.systemFont(ofSize: 22)
        
        optionD.font = UIFont.systemFont(ofSize: 22)
        
        quizView.addSubview(bg)
        
        quizView.addSubview(questionLabel)
        
        quizView.addSubview(button1)
        
        quizView.addSubview(button2)
        
        quizView.addSubview(button3)
        
        quizView.addSubview(button4)
        
        quizView.addSubview(optionA)
        
        quizView.addSubview(optionB)
        
        quizView.addSubview(optionC)
        
        quizView.addSubview(optionD)
        
        optionA.textColor = UIColor.black
        
        optionB.textColor = UIColor.black
        
        optionC.textColor = UIColor.black
        
        optionD.textColor = UIColor.black
        
        tickPhoto.isHidden = true
        
        tickPhoto.contentMode = .center
        
        quizView.addSubview(A)
        
        quizView.addSubview(B)
        
        quizView.addSubview(C)
        
        quizView.addSubview(D)
        
        quizView.addSubview(tickPhoto)
        
        quizView.addSubview(status)
        
        view.bringSubview(toFront: guidanceLabel)
        
        print(qIndex)
        
        resetMCQVals()
        
        if run == false {
            
            timePassForMCQ()
            
            run = true
        }
        
    }
    
    @objc func timePassForMCQ() {
        
        if !(status.text == "time left: ∞") {
            
            if status.text == "time left: 0" {
                
                correctionArray.insert(false, at: 0)
                
                updateMCQuestion()
                
                resetMCQVals()
                
            } else {
                
                let n = Int(String(status.text!.dropFirst(11)))
                
                print(String(status.text!.dropFirst(11)))
                
                status.text = "time left: " + String(n! - 1)
                
                _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timePassForMCQ), userInfo: [], repeats: false)
                
            }
            
            if status.text == "time left: 5" {
                
                status.font = UIFont.boldSystemFont(ofSize: 17)
                
                status.textColor = UIColor.red
                
            }
            
        }
        
    }
    
    var mcqValue = -1
    
    @objc func checkIfAnsIs1() {
        
        if mcqValue == 0 {
            
            fullMCQCheck()
            
            resetMCQVals()
            
            mcqValue = -1
            
        } else {
            
            mcqValue = 0
            
            button4.backgroundColor = UIColor.white
            
            button2.backgroundColor = UIColor.white
            
            button3.backgroundColor = UIColor.white
            
            tickPhoto.isHidden = false
            
            button1.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            
            optionA.textColor = UIColor.white
            
            optionB.textColor = UIColor.black
            
            optionC.textColor = UIColor.black
            
            optionD.textColor = UIColor.black
            
            A.text = "✓"
            
            B.text = "B"
            
            C.text = "C"
            
            D.text = "D"
            
            optionA.font = UIFont.boldSystemFont(ofSize: 22)
            
            tickPhoto.isHidden = false
            
            tickPhoto.frame = A.frame
            
        }
        
    }
    
    @objc func checkIfAnsIs2() {
        
        if mcqValue == 1 {
            
            fullMCQCheck()
            
            resetMCQVals()
            
            mcqValue = -1
            
        } else {
            
            mcqValue = 1
        
            button2.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
            button4.backgroundColor = UIColor.white
        
            button3.backgroundColor = UIColor.white
        
            button1.backgroundColor = UIColor.white
            
            optionA.textColor = UIColor.black
            
            optionB.textColor = UIColor.white
            
            optionC.textColor = UIColor.black
            
            optionD.textColor = UIColor.black
            
            B.text = "✓"
            
            A.text = "A"
            
            C.text = "C"
            
            D.text = "D"
            
            optionB.font = UIFont.boldSystemFont(ofSize: 22)
            
            tickPhoto.isHidden = false
            
            tickPhoto.frame = B.frame
            
        }
        
    }
    
    @objc func checkIfAnsIs3() {
        
        if mcqValue == 2 {
            
            fullMCQCheck()
            
            resetMCQVals()
            
            mcqValue = -1
            
        } else {
            
            mcqValue = 2
        
            button3.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
            button2.backgroundColor = UIColor.white
        
            button4.backgroundColor = UIColor.white
        
            button1.backgroundColor = UIColor.white
            
            optionA.textColor = UIColor.black
            
            optionB.textColor = UIColor.black
            
            optionC.textColor = UIColor.white
            
            optionD.textColor = UIColor.black
            
            C.text = "✓"
            
            B.text = "B"
            
            A.text = "A"
            
            D.text = "D"
            
            optionC.font = UIFont.boldSystemFont(ofSize: 22)
            
            tickPhoto.isHidden = false
            
            tickPhoto.frame = C.frame
            
        }
        
    }
    
    @objc func checkIfAnsIs4() {
        
        if mcqValue == 3 {
            
            fullMCQCheck()
            
            resetMCQVals()
            
            mcqValue = -1
            
        } else {
            
            mcqValue = 3
            
            button3.backgroundColor = UIColor.white
            
            button2.backgroundColor = UIColor.white
            
            button4.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            
            button1.backgroundColor = UIColor.white
            
            optionA.textColor = UIColor.black
            
            optionB.textColor = UIColor.black
            
            optionC.textColor = UIColor.black
            
            optionD.textColor = UIColor.white
            
            D.text = "✓"
            
            B.text = "B"
            
            C.text = "C"
            
            A.text = "A"
            
            optionD.font = UIFont.boldSystemFont(ofSize: 22)
            
            tickPhoto.isHidden = false
            
            tickPhoto.frame = D.frame
            
        }
        
    }
    
    func resetMCQVals() {
        
        button4.backgroundColor = UIColor.white
        
        button2.backgroundColor = UIColor.white
        
        button3.backgroundColor = UIColor.white
        
        button1.backgroundColor = UIColor.white
        
        optionA.textColor = UIColor.black
        
        optionB.textColor = UIColor.black
        
        optionC.textColor = UIColor.black
        
        optionD.textColor = UIColor.black
        
        A.text = "A"
        
        B.text = "B"
        
        C.text = "C"
        
        D.text = "D"
        
        optionA.font = UIFont.systemFont(ofSize: 22)
        
        optionB.font = UIFont.systemFont(ofSize: 22)
        
        optionC.font = UIFont.systemFont(ofSize: 22)
        
        optionD.font = UIFont.systemFont(ofSize: 22)
        
        tickPhoto.isHidden = true
        
    }
    
    func fullMCQCheck() {
        
        print(qIndex)
        
        if correctAnswer[qIndex] == mcqValue {
            
            correctionArray.insert(true, at: 0)
            
        } else {
            
            correctionArray.insert(false, at: 0)
            
        }
        
        updateMCQuestion()
        
    }
    
    var correct = 0
    
    func updateMCQuestion() {
        
        print("TEST ENTER")
        
        if timeLimit == -1 {
            
            status.text = "time left: ∞"
            
        } else {
            
            status.text = "time left: \(timeLimit)"
            
        }
        
        status.textColor = UIColor.black
        
        status.font = UIFont.systemFont(ofSize: 17)
        
        qNumber = qNumber + 1
        
        guidanceLabel.text = "Question Number " + String(qNumber)
        
        qIndex = qIndex - 1
        
        print("q", qIndex)
        
        if qIndex > -1 {
            
            questionLabel.text = questions[qIndex]
            
            optionA.text = answers[qIndex][0]
            
            optionB.text = answers[qIndex][1]
            
            optionC.text = answers[qIndex][2]
            
            optionD.text = answers[qIndex][3]
            
            print("UPDATED?")
            
        } else {
            
            status.text = "time left: ∞"
            
            correct = 0
            
            for item in correctionArray {
                
                if item == true {
                    
                    correct = correct + 1
                    
                }
                
            }
            
            guidanceLabel.text = "You're Done!"
            
            guidanceLabel.isHidden = true
            
            questionLabel.text = "You scored a " + String(correct) + "/" + String(correctionArray.count)
            
            button1.isHidden = true
            
            button2.isHidden = true
            
            button3.isHidden = true
            
            button4.isHidden = true
            
            createQR()
            
        }
        
    }
    
    //Numeric Quiz
    
    let inputField = UITextField(frame: CGRect.null)
    
    let drawView = UIImageView(frame: CGRect.null)
    
    let b1 = UIButton(frame: CGRect.null)
    
    let b2 = UIButton(frame: CGRect.null)
    
    let b3 = UIButton(frame: CGRect.null)
    
    let b4 = UIButton(frame: CGRect.null)
    
    let b5 = UIButton(frame: CGRect.null)
    
    let b6 = UIButton(frame: CGRect.null)
    
    let b7 = UIButton(frame: CGRect.null)
    
    let b8 = UIButton(frame: CGRect.null)
    
    let b9 = UIButton(frame: CGRect.null)
    
    let b0 = UIButton(frame: CGRect.null)
    
    let bd = UIButton(frame: CGRect.null)
    
    let bc = UIButton(frame: CGRect.null)
    
    func initNQuiz() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        //let bg = CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 100)
        
        //bg.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.9450980392, blue: 0.9960784314, alpha: 1)
        
        guidanceLabel.text = "Question Number " + String(qNumber)
        
        guidanceLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        guidanceLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        guidanceLabel.frame = CGRect(x: 20, y: 20, width: view.frame.width / 4, height: 45)
        
        guidanceLabel.textAlignment = .left
        
        qIndex = questions.count - 1
        
        quizView.frame = view.frame
        
        view.addSubview(quizView)
        
        questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        questionLabel.frame = CGRect(x: 40, y: 70, width: view.frame.width - 20, height: 100)
        
        questionLabel.textAlignment = .left
        
        inputField.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.black)
        
        inputField.borderStyle = .roundedRect
        
        inputField.text = ""
        
        inputField.textAlignment = .center
        
        inputField.isEnabled = false
        
        drawView.frame = CGRect(x: view.frame.width / 4 + 20, y: 130, width: 3 * view.frame.width / 4 - 30, height: 4 * view.frame.height / 5)
        
        drawView.layer.borderWidth = 2
        
        drawView.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
        
        questionLabel.text = questions[qIndex]
        
        questionLabel.numberOfLines = 10
        
        button1.setTitleColor(UIColor.white, for: [])
        
        button1.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        button1.layer.cornerRadius = 10
        
        button1.setTitle("Next >", for: [])
        
        button1.addTarget(self, action: #selector(self.checkForN), for: .touchUpInside)
        
        //quizView.addSubview(bg)
        
        let w16 = view.frame.width / 16
        
        let w8 = view.frame.width / 8
        
        b1.frame = CGRect(x: 20, y: 260 + w8 + 20, width: w16, height: w16)
        
        b2.frame = CGRect(x: w16 + 30, y: 260 + w8 + 20, width: w16, height: w16)
        
        b3.frame = CGRect(x: 2 * w16 + 40, y: 260 + w8 + 20, width: w16, height: w16)
        
        b4.frame = CGRect(x: 20, y: 260 + w16 + 10, width: w16, height: w16)
        
        b5.frame = CGRect(x: w16 + 30, y: 260 + w16 + 10, width: w16, height: w16)
        
        b6.frame = CGRect(x: 2 * w16 + 40, y: 260 + w16 + 10, width: w16, height: w16)
        
        b7.frame = CGRect(x: 20, y: 260, width: w16, height: w16)
        
        b8.frame = CGRect(x: w16 + 30, y: 260, width: w16, height: w16)
        
        b9.frame = CGRect(x: 2 * w16 + 40, y: 260, width: w16, height: w16)
        
        bd.frame = CGRect(x: 20, y: 260 + 3 * w16 + 30, width: w16, height: w16)
        
        b0.frame = CGRect(x: w16 + 30, y: 260 + 3 * w16 + 30, width: w16, height: w16)
        
        bc.frame = CGRect(x: 2 * w16 + 40, y: 260 + 3 * w16 + 30, width: w16, height: w16)
        
        button1.frame = CGRect(x: 20, y: 260 + 4 * w16 + 40, width: 3 * w16 + 20, height: 50)
        
        b1.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b2.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b3.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b4.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b5.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b6.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b7.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b8.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b9.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b0.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        bd.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        bc.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        b1.layer.cornerRadius = 10
        
        b2.layer.cornerRadius = 10
        
        b3.layer.cornerRadius = 10
        
        b4.layer.cornerRadius = 10
        
        b5.layer.cornerRadius = 10
        
        b6.layer.cornerRadius = 10
        
        b7.layer.cornerRadius = 10
        
        b8.layer.cornerRadius = 10
        
        b9.layer.cornerRadius = 10
        
        b0.layer.cornerRadius = 10
        
        bc.layer.cornerRadius = 10
        
        bd.layer.cornerRadius = 10
        
        b1.setTitle("1", for: [])
        
        b2.setTitle("2", for: [])
        
        b3.setTitle("3", for: [])
        
        b4.setTitle("4", for: [])
        
        b5.setTitle("5", for: [])
        
        b6.setTitle("6", for: [])
        
        b7.setTitle("7", for: [])
        
        b8.setTitle("8", for: [])
        
        b9.setTitle("9", for: [])
        
        b0.setTitle("0", for: [])
        
        bd.setTitle(".", for: [])
        
        bc.setTitle("C", for: [])
        
        b1.addTarget(self, action: #selector(self.add1), for: .touchUpInside)
        
        b2.addTarget(self, action: #selector(self.add2), for: .touchUpInside)
        
        b3.addTarget(self, action: #selector(self.add3), for: .touchUpInside)
        
        b4.addTarget(self, action: #selector(self.add4), for: .touchUpInside)
        
        b5.addTarget(self, action: #selector(self.add5), for: .touchUpInside)
        
        b6.addTarget(self, action: #selector(self.add6), for: .touchUpInside)
        
        b7.addTarget(self, action: #selector(self.add7), for: .touchUpInside)
        
        b8.addTarget(self, action: #selector(self.add8), for: .touchUpInside)
        
        b9.addTarget(self, action: #selector(self.add9), for: .touchUpInside)
        
        b0.addTarget(self, action: #selector(self.add0), for: .touchUpInside)
        
        bd.addTarget(self, action: #selector(self.addD), for: .touchUpInside)
        
        bc.addTarget(self, action: #selector(self.addC), for: .touchUpInside)
        
        inputField.frame = CGRect(x: 10, y: 130, width: b3.frame.origin.x + b3.frame.width, height: 100)
        
        status.textColor = UIColor.black
        
        status.font = UIFont.systemFont(ofSize: 17)
        
        if timeLimit == -1 {
            
            status.text = "time left: ∞"
            
        } else {
            
            status.text = "time left: \(timeLimit)"
            
        }
        
        status.textAlignment = .center
        
        status.frame = CGRect(x: view.frame.width / 4 + 20, y: 130, width: 3 * view.frame.width / 4 - 30, height: 30)
        
        quizView.addSubview(questionLabel)
        
        quizView.addSubview(button1)
        
        quizView.addSubview(inputField)
        
        quizView.addSubview(drawView)
        
        quizView.addSubview(status)
        
        view.addSubview(b1)
        
        view.addSubview(b2)
        
        view.addSubview(b3)
        
        view.addSubview(b4)
        
        view.addSubview(b5)
        
        view.addSubview(b6)
        
        view.addSubview(b7)
        
        view.addSubview(b8)
        
        view.addSubview(b9)
        
        view.addSubview(b0)
        
        view.addSubview(bd)
        
        view.addSubview(bc)
        
        print(qIndex)
        
        if run == false {
            
            timePassForN()
            
            run = true
            
        }
        
    }
    
    @objc func add1() {
        
        inputField.text = inputField.text! + "1"
        
    }
    
    @objc func add2() {
        
        inputField.text = inputField.text! + "2"
        
    }
    
    @objc func add3() {
        
        inputField.text = inputField.text! + "3"
        
    }
    
    @objc func add4() {
        
        inputField.text = inputField.text! + "4"
        
    }
    
    @objc func add5() {
        
        inputField.text = inputField.text! + "5"
        
    }
    
    @objc func add6() {
        
        inputField.text = inputField.text! + "6"
        
    }
    
    @objc func add7() {
        
        inputField.text = inputField.text! + "7"
        
    }
    
    @objc func add8() {
        
        inputField.text = inputField.text! + "8"
        
    }
    
    @objc func add9() {
        
        inputField.text = inputField.text! + "9"
        
    }
    
    @objc func add0() {
        
        inputField.text = inputField.text! + "0"
        
    }
    
    @objc func addC() {
        
        inputField.text = ""
        
    }
    
    @objc func addD() {
        
        inputField.text = inputField.text! + "."
        
    }
    
    @objc func timePassForN() {
        
        if !(status.text == "time left: ∞") {
            
            if status.text == "time left: 0" {
                
                checkForN()
                
            } else {
                
                let n = Int(String(status.text!.dropFirst(11)))
                
                print(String(status.text!.dropFirst(11)))
                
                status.text = "time left: " + String(n! - 1)
                
                _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timePassForN), userInfo: [], repeats: false)
                
            }
            
            if status.text == "time left: 5" {
                
                status.font = UIFont.boldSystemFont(ofSize: 17)
                
                status.textColor = UIColor.red
                
            }
            
        }
        
    }
    
    @objc func checkForN() {
        
        let inStr = inputField.text!
        
        if inStr == "" {
            
            correctionArray.insert(false, at: 0)
            
        } else {
            
            if Decimal(string: inStr) == Decimal(correctAnswer[qIndex]) {
                
                correctionArray.insert(true, at: 0)
                
            } else {
                
                correctionArray.insert(false, at: 0)
                
            }
            
        }
        
        updateNQuestion()
        
    }
    
    func updateNQuestion() {
        
        print("TEST ENTER")
        
        if timeLimit == -1 {
            
            status.text = "time left: ∞"
            
        } else {
            
            status.text = "time left: \(timeLimit)"
            
        }
        
        status.textColor = UIColor.black
        
        status.font = UIFont.systemFont(ofSize: 17)
        
        qNumber = qNumber + 1
        
        guidanceLabel.text = "Question Number " + String(qNumber)
        
        qIndex = qIndex - 1
        
        if qIndex > -1 {
            
            questionLabel.text = questions[qIndex]
            
            inputField.text = ""
            
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timePassForN), userInfo: [], repeats: false)
            
            print("UPDATED?")
            
        } else {
            
            correct = 0
            
            for item in correctionArray {
                
                if item == true {
                    
                    correct = correct + 1
                    
                }
                
            }
            
            guidanceLabel.text = "You're Done!"
            
            questionLabel.text = "You scored a " + String(correct) + "/" + String(correctionArray.count)
            
            button1.isHidden = true
            
            button2.isHidden = true
            
            button3.isHidden = true
            
            button4.isHidden = true
            
            createQR()
            
        }
        
    }
    
    func createQR() {
        
        quizView.removeFromSuperview()
        
        let id = UserDefaults.standard.string(forKey: "UserID")
        
        if UserDefaults.standard.string(forKey: "UserID") == nil {
            
            UserDefaults.standard.set(String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9))+String(arc4random_uniform(9)), forKey: "UserID")
            
        }
        
        var dataToStore = id! + quizData.components(separatedBy: "-")[1]
        
        for ans in correctionArray {
            
            var post = 0
            
            if ans == true {
                
                post = 1
                
            }
            
            dataToStore = dataToStore + String(post)
            
        }
        
        let data = dataToStore.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        let qrcodeImage = filter?.outputImage
        
        var imgQRCode = UIImageView(frame: CGRect.null)
        
        imgQRCode = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.height - 60, height: view.frame.width - view.frame.height))
        
        guidanceLabel.frame = CGRect(x: view.frame.height, y: 100, width: view.frame.width - view.frame.height, height: guidanceLabel.frame.height)
        
        questionLabel.frame = CGRect(x: view.frame.height, y: questionLabel.frame.origin.y, width: view.frame.width - view.frame.height, height: questionLabel.frame.height)
        
        imgQRCode.frame = CGRect(x: 0, y: 0, width: self.view.frame.height - 60, height: self.view.frame.height - 60)
        
        imgQRCode.center = view.center
        
        imgQRCode.contentMode = .scaleToFill
        
        imgQRCode.backgroundColor = UIColor.white
        
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        l.backgroundColor = UIColor.white
        
        view.addSubview(l)
        
        let scaleX = imgQRCode.frame.width / (qrcodeImage?.extent.size.width)!
        
        let scaleY = imgQRCode.frame.height / (qrcodeImage?.extent.size.height)!
        
        let transformedImage = qrcodeImage?.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        view.addSubview(imgQRCode)
        
        imgQRCode.image = UIImage(ciImage: transformedImage!)
        
        let hideView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        
        hideView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        let gdjobLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 2 - 50, width: view.frame.width, height: 50))
        
        let markLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 2 + 50, width: view.frame.width, height: 50))
        
        markLabel.alpha = 0
        
        gdjobLabel.alpha = 0
        
        if Double(correct) / Double(correctionArray.count) > 0.6 {
            
            gdjobLabel.text = "Good Job!"
            
        } else {
            
            gdjobLabel.text = "Poor Result :("
            
        }
        
        markLabel.text = String(correct) + "/" + String(correctionArray.count)
        
        markLabel.textAlignment = .center
        
        gdjobLabel.textAlignment = .center
        
        markLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        
        gdjobLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        
        gdjobLabel.textColor = UIColor.white
        
        markLabel.textColor = UIColor.white
        
        hideView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
         
        view.addSubview(hideView)
        
        view.addSubview(gdjobLabel)
        
        view.addSubview(markLabel)
        
        /////////guidanceLabel.isHidden == true
        
        questionLabel.removeFromSuperview()
        
        UIView.animate(withDuration: 1, animations: {
            
            markLabel.alpha = 1
            
            gdjobLabel.alpha = 1
            
        }, completion: {
            
            _ in
            
            UIView.animate(withDuration: 0.5, delay: 5, options: [], animations: {
                
                hideView.center = CGPoint(x: self.view.frame.width / 2, y: -self.view.frame.height * 2)
                
                gdjobLabel.center = CGPoint(x: self.view.frame.width / 2, y: -self.view.frame.height * 2)
                
                markLabel.center = CGPoint(x: self.view.frame.width / 2, y: -self.view.frame.height * 2)
                
            })
            
        })
        
        let goBack = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        goBack.addTarget(self, action: #selector(self.GoBack), for: .touchUpInside)
        
        view.addSubview(goBack)
        
    }
    
    var unlockCode = "@@@@@@"
    
    @objc func GoBack() {
        
        let alertController = UIAlertController(title: "Remember to scan your QR!", message: "Enter the code the teacher gives you to go back", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            
            textField.text = ""
            
            textField.clearButtonMode = .always
            
            textField.autocapitalizationType = .none
            
        }
        
        alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: {
            
            (_) in
            
            let textField = alertController.textFields![0]
            
            if textField.text == self.unlockCode {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: "main")
                
                self.present(vc, animated: false, completion: nil)
                
            } else {
                
                let v = UIAlertController(title: "Wrong Code", message: "If the teacher didn't scan it and give you the code, remind him to!", preferredStyle: .alert)
                
                v.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_) in}))
                
                self.present(v, animated: true, completion: nil)
                
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    var isSwiping : Bool!
    
    var lastPoint:CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isSwiping = false
        
        if let touch = touches.first{
            
            lastPoint = touch.location(in: drawView)
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,  with event: UIEvent?) {
        
        isSwiping = true
        
        if let touch = touches.first{
            
            let currentPoint = touch.location(in: drawView)
            
            UIGraphicsBeginImageContext(self.drawView.frame.size)
            
            self.drawView.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawView.frame.size.width, height: self.drawView.frame.size.height))
            
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
            
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            
            UIGraphicsGetCurrentContext()?.setLineWidth(5.0)
            
            UIGraphicsGetCurrentContext()?.setStrokeColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor)
            
            UIGraphicsGetCurrentContext()?.strokePath()
            
            self.drawView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            lastPoint = currentPoint
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(!isSwiping) {
            
            UIGraphicsBeginImageContext(self.drawView.frame.size)
            
            self.drawView.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawView.frame.size.width, height: self.drawView.frame.size.height))
            
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            
            UIGraphicsGetCurrentContext()?.setLineWidth(5.0)
            
            UIGraphicsGetCurrentContext()?.setStrokeColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor)
            
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            
            UIGraphicsGetCurrentContext()?.strokePath()
            
            self.drawView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
        }
        
    }
    
    func clearDrawView() {
        
        self.drawView.image = nil
        
    }
    
}
