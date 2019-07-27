//
//  motionViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 5/13/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.
//

import UIKit
import CoreMotion

class motionViewController: UIViewController {
    
    let motionManager = CMMotionManager()

    @IBOutlet weak var labelx: UILabel!
    
    @IBOutlet weak var labely: UILabel!
    
    @IBOutlet weak var labelz: UILabel!
    
    @IBOutlet weak var set: UIButton!
    
    @IBOutlet weak var x: UIButton!
    
    @IBOutlet weak var y: UIButton!
    
    @IBOutlet weak var z: UIButton!
    
    @IBOutlet weak var auto: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if motionManager.isDeviceMotionAvailable {
            //do something interesting
        }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
            
                (deviceMotion, error) -> Void in
                
                if(error == nil) {
                    
                    self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
                    
                } else {
                    
                    //handle the error
                    
                }
            
        })
        
        motionManager.deviceMotionUpdateInterval = 0.1
        
        set.addTarget(self, action: #selector(self.fix), for: .touchUpInside)
        
        auto.addTarget(self, action: #selector(self.track), for: .touchUpInside)
        
        x.addTarget(self, action: #selector(self.showX), for: .touchUpInside)
        
        y.addTarget(self, action: #selector(self.showY), for: .touchUpInside)
        
        z.addTarget(self, action: #selector(self.showZ), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var addxValue : Double = 0
    
    var addyValue : Double = 0
    
    var addzValue : Double = 0
    
    var roll : Double = 0
    
    var pitch : Double = 0
    
    var yaw  : Double = 0
    
    @objc func fix() {
        
        addxValue = roll
        
        addyValue = pitch
        
        addzValue = yaw
        
    }
    
    @objc func showX() {
        
        labelx.isHidden = !(labelx.isHidden)
        
    }
    
    @objc func showY() {
        
        labely.isHidden = !(labely.isHidden)
        
    }
    
    @objc func showZ() {
        
        labelz.isHidden = !(labelz.isHidden)
        
    }
    
    var doTrack = false
    
    @objc func track() {
        
        doTrack = !(doTrack)
        
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / Double.pi * radians
    }

    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
        roll = degrees(radians: attitude.roll)
        pitch = degrees(radians: attitude.pitch)
        yaw = degrees(radians: attitude.yaw)
        print("Roll: \(roll), Pitch: \(pitch), Yaw: \(yaw)")
        print("OFFSET: \(addxValue),\(addyValue),\(addzValue)")
        
        let xVal = abs(Int(roll))
        
        let yVal = abs(Int(pitch))
        
        //let zVal = abs(Int(yaw))
        
        if doTrack == true {
            
            if xVal > 50 {
                
                labelx.text = String(yVal)
                
                labely.text = "yVal"
                
                labelz.text = ""
                
            } else if yVal > 50 {
                
                labelx.text = String(xVal)
                
                labely.text = "xVal"
                
                labelz.text = ""
                
            } else {
                
                var flat = 0
                
                if yVal > 5 {
                    
                    if xVal > 5  {
                        
                        flat = ( xVal + yVal ) / 2
                        
                    } else {
                        
                        if yVal > xVal {
                            
                            flat = yVal
                            
                        } else {
                            
                            flat = xVal
                            
                        }
                        
                    }
                    
                } else {
                    
                    if yVal > xVal {
                        
                        flat = yVal
                        
                    } else {
                        
                        flat = xVal
                        
                    }
                    
                }
                
                labelx.text = String(flat)
                
                labely.text = "FLAT"
                
                labelz.text = ""
                
            }
            
        } else {
            
            labelx.text = "X: " + String(Int(roll - addxValue))
            
            labely.text = "Y: " + String(Int(pitch - addyValue))
            
            labelz.text = "Z: " + String(Int(yaw - addzValue))
            
        }
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class ruleViewController: UIViewController {
    
    let pro = 12.9
    
    let mini = 7.9
    
    let air = 9.7
    
    let rule = UILabel(frame: CGRect.null)
    
    let lengthDisplay = UILabel(frame: CGRect.null)
    
    var multiplier : CGFloat = 0
    
    var useCms = true
    
    let back = UIButton(frame: CGRect.null)
    
    let cmButton = UIButton(frame: CGRect.null)
    
    let alignButton = UIButton(frame: CGRect.null)
    
    var isCentered = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        print(UIDevice.current.inch)
        
        let use = UIDevice.current.inch
        
        multiplier = sqrt(CGFloat(pow(use,2))/CGFloat(pow(UIScreen.main.bounds.size.width,2) + pow(UIScreen.main.bounds.size.height,2)))
        
        print(multiplier)
        
        print(multiplier * UIScreen.main.bounds.size.width)
        
        print(multiplier * UIScreen.main.bounds.size.height)
        
        setupRule()
        
        let sizeGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        
        view.addGestureRecognizer(sizeGesture)
        
        lengthDisplay.text = String(describing: getValue(cms: useCms))
        
        lengthDisplay.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 100)
        
        lengthDisplay.textColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
        
        lengthDisplay.textAlignment = .center
        
        lengthDisplay.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.black)
        
        back.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
        
        back.setImage(#imageLiteral(resourceName: "Disclosure Indicator"), for: [])
        
        back.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        
        back.frame = CGRect(x: 20, y: 30, width: 40, height: 40)
        
        cmButton.setTitle("cm", for: [])
        
        cmButton.addTarget(self, action: #selector(self.convertUnits), for: .touchUpInside)
        
        cmButton.frame = CGRect(x: view.frame.width - 120, y: 50, width: 100, height: 40)
        
        cmButton.layer.cornerRadius = 10
        
        cmButton.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
        
        alignButton.setTitle("centered", for: [])
        
        alignButton.addTarget(self, action: #selector(self.align), for: .touchUpInside)
        
        alignButton.frame = CGRect(x: view.frame.width - 120, y: 100, width: 100, height: 40)
        
        alignButton.layer.cornerRadius = 10
        
        alignButton.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
        
        view.addSubview(lengthDisplay)
        
        view.addSubview(back)
        
        view.addSubview(cmButton)
        
        view.addSubview(alignButton)
        
    }
    
    @objc func align() {
        
        isCentered = !(isCentered)
        
        if isCentered {
            
            rule.center = view.center
            
        } else {
            
            rule.frame = CGRect(x: 0, y: view.frame.height / 2, width: rule.frame.width, height: 5)
            
        }
        
    }
    
    @objc func convertUnits() {
        
        useCms = !(useCms)
        
        if useCms {
            
            cmButton.setTitle("cm", for: [])
            
        } else {
            
            cmButton.setTitle("inch", for: [])
            
        }
        
        lengthDisplay.text = String(describing: getValue(cms: useCms))
        
    }
    
    @objc func goBack() {
        
        print("PERFORM")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "main")
        
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        
        if isCentered {
            
            let translation = recognizer.translation(in: self.view)
            
            rule.frame = CGRect(x: 0, y: 0, width: rule.frame.width + translation.x, height: 5)//.center = CGPoint(x:questionView.center.x + translation.x, y:questionView.center.y)
            
            rule.center = view.center
            
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            
            lengthDisplay.text = String(describing: getValue(cms: useCms))
            
        } else {
            
            let translation = recognizer.translation(in: self.view)
            
            rule.frame = CGRect(x: 0, y: view.frame.height / 2, width: rule.frame.width + translation.x, height: 5)
            
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            
            lengthDisplay.text = String(describing: getValue(cms: useCms))
            
        }
        
    }
    
    func setupRule() {
        
        rule.frame = CGRect(x: 0, y: 0, width: 100, height: 5)
        
        rule.backgroundColor = UIColor.black
        
        rule.center = view.center
        
        view.addSubview(rule)
        
    }
    
    func getValue(cms: Bool) -> CGFloat {
        
        if cms {
            
            return rule.frame.width * multiplier * CGFloat(2.54)
            
        } else {
            
            return rule.frame.width * multiplier
            
        }
        
    }
    
}

public extension UIDevice {
    
    var inch: Double {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4", "iPad3,1", "iPad3,2", "iPad3,3", "iPad3,4", "iPad3,5", "iPad3,6", "iPad4,1", "iPad4,2", "iPad4,3" :
            return 9.7
            
        case "iPad5,3", "iPad5,4", "iPad2,5", "iPad2,6", "iPad2,7", "iPad4,4", "iPad4,5", "iPad4,6", "iPad4,7", "iPad4,8", "iPad4,9", "iPad5,1", "iPad5,2" :
            return 7.9
            
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":
            return 12.9
            
        default:
            return 0
            
        }
    }
    
}



