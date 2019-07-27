//
//  quizAssignerViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 6/21/18.
//  Copyright © 2018 Tareq El Dandachi. All rights reserved.
//

//
//  quizViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 5/12/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.
//

import UIKit

import AVFoundation

import CoreImage

class quizAssignerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        var question = "MCQ?Q.Which one of these is a quarkUpGluonPhotonElectronA;true;false,Q.What does ALU stand forArithmetic Linguistic UtiliserAmerican-Lebanese UnionArithmetic Logic UnitAssociative Logic UnitC;true;falseTOF?Q.This answer is truetrue;false;false,Q.This answer is falsefalse;false;false,Q.2 ✖️ 3 = 6true;false;false"
        
        question = "Lipsum8D-TESTonFTB?Lorem ipsum dolor sit amet, * adipiscing elit, sed do eiusmod tempor * ut labore et dolore magna aliqua.consectetur,cupidatat,reprehenderit,voluptate,irure,adipiscing;sunt,incididunt;true;false"
        
        question = "Solenoids12IB-PhysicsonMCQ?Solenoids generate aMagnetic FieldBuzzing SoundBeeping SoundExcess UV RadiationA;true;false,The magnetic field inside an infinitely long solenoid isHeterogeneousHomogeneousStrongWeakB;false;falseTOF?Electromechanical solenoids consist of an electromagnetically inductive coil, wound around a movable steel or iron slug.true;false;false,Solenoids break Faraday's law of inductionfalse;false;falseFTB?A long straight coil of * can be used to * a nearly uniform * field similar to that of a bar *.iron,system,solenoid,current,voltage;wire,generate,magnetic,magnet;true;false,In physics, the term refers to a coil whose * is substantially greater than its *, often wrapped around a * coreiron,width,radius;length,diameter,metallic;true;false"
        
        //question = "Solenoids12IB-PhysicsonTOF?Electromechanical solenoids consist of an electromagnetically inductive coil, wound around a movable steel or iron slug.true;false;false,Solenoids break Faraday's law of inductionfalse;false;falseFTB?A long straight coil of * can be used to * a nearly uniform * field similar to that of a bar *.iron,system,solenoid,current,voltage;wire,generate,magnetic,magnet;true;false,In physics, the term refers to a coil whose * is substantially greater than its *, often wrapped around a * coreiron,width,radius;length,diameter,metallic;true;false"
        
        breakQuizData(str: question)
        
        guidanceLabel.frame = CGRect(x: 0, y: 37, width: view.frame.width, height: 66)
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //previewLayer!.frame = previewView.bounds
        
    }
    
    var questions : [String] = []
    
    var answers = [[""]]
    
    var correctAnswer : [Int] = []
    
    var answersForFTB : [[String]] = []
    
    var quizData : String = "NAME(#)ID"
    
    var timeLimit = -1
    
    var hasCalc = [] as! [Bool]
    
    var hasDraw = [] as! [Bool]
    
    var types = [] as! [String]
    
    var typeNumber = 0
    
    var typeIndex = 0
    
    var qArray = [] as! [String]
    
    var newQuestions: [String : [String]] = [:]
    
    var quizName = ""
    
    var subject = ""
    
    var shareable = false
    
    func breakQuizData(str: String) {
        
        //"MCQ?Q.DSAOPT AOPT BOPT COPT DC;true;false,Q.POPOPT A2OPT B2OPT C2OPT D2A;true;falseTOF?Q.RFfalse;false;false"
        
        var importarray = str.components(separatedBy: "")
        
        quizName = importarray[0]
        
        subject = importarray[1]
        
        if importarray[2].contains("on") {
            
            shareable = true
            
        } else {
            
            shareable = false
            
        }
        
        print(quizName, subject, shareable)
        
        typeNumber = 0
        
        print("IA", importarray)
        
        importarray = importarray.filter { $0 != "" }
        
        importarray = Array(importarray.dropFirst(3))
        
        for item in importarray {
            
            types.append(String(item.prefix(3)))
            
            qArray.append(String(item.dropFirst(4)))
            
            typeNumber = typeNumber + 1
            
        }
        
        print(types)
        
        videoPreviewLayer?.isHidden = true
        
        answers = []
        
        questions = []
        
        correctAnswer = []
        
        timeLimit = 0
        
        hasCalc = []
        
        hasDraw = []
        
        var tempindex = 0
        
        for i in types {
            
            var temp = qArray[tempindex].components(separatedBy: ",")
            
            var tempQ = [] as! [String]
            
            for i in temp {
                
                tempQ.append(String(i).replacingOccurrences(of: "", with: ""))
                
            }
            
            newQuestions[i] = tempQ
            
            tempindex = tempindex + 1
            
        }
        
        print("NEWQ", newQuestions)
        
        group(n: typeIndex)
        
    }
    
    var buttonSwitch = UIButton(frame: CGRect.null)
    
    func group(n:Int) {
        
        print(n)
        
        print("THINKING HMMMM...")
        
        if n > types.count - 1 {
            
            print("DONEDONEDONEDONE")
            
            questionLabel = UILabel(frame: CGRect.null)
            
            guidanceLabel.text = "You're Done!"
            
            guidanceLabel.font = UIFont.systemFont(ofSize: 36, weight: .black)
            
            guidanceLabel.textColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
            
            guidanceLabel.text = "Outstanding Work!"
            
            //questionLabel.text = "You scored a " + String(correct) + "/" + String(correctionArray.count)
            
            questionLabel.text = "Quiz Completed"
            
            guidanceLabel.frame = CGRect(x: 0, y: 74, width: view.frame.width, height: 40)
            
            questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            questionLabel.frame = CGRect(x: 0, y: 47, width: view.frame.width, height: 27)
            
            let quizNameLabel = UILabel(frame: CGRect(x: 0, y: 160, width: view.frame.width/2, height: 50))
            
            extraLabel = UILabel(frame: CGRect(x: 0, y: 210, width: view.frame.width/2, height: 50))
            
            let dataLabel = UILabel(frame: CGRect(x: view.frame.width/2, y: 160, width: view.frame.width/2, height: 50))
            
            quizNameLabel.text = subject
            
            extraLabel.text = quizName
            
            quizNameLabel.font = UIFont.systemFont(ofSize: 36, weight: .medium)
            
            quizNameLabel.textColor = UIColor.black
            
            questionLabel.backgroundColor = UIColor.white
            
            questionLabel.textColor = UIColor.black
            
            extraLabel.textColor = UIColor.black
            
            questionLabel.shadowColor = UIColor.white
            
            dataLabel.text = "Awards"
            
            dataLabel.font = UIFont.systemFont(ofSize: 36, weight: .black)
            
            dataLabel.textColor = #colorLiteral(red: 1, green: 0.6498119235, blue: 0, alpha: 1)
            
            dataLabel.textAlignment = .center
            
            extraLabel.font = UIFont.systemFont(ofSize: 24)
            
            quizNameLabel.textAlignment = .center
            
            extraLabel.textAlignment = .center
            
            questionLabel.textAlignment = .center
            
            guidanceLabel.textAlignment = .center
            
            view.addSubview(quizNameLabel)
            
            view.addSubview(dataLabel)
            
            view.addSubview(questionLabel)
            
            view.addSubview(extraLabel)
            
            let markLabel = UILabel(frame: CGRect(x: 0, y: 270, width: view.frame.width/2, height: 50))
            
            markLabel.textColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
            
            markLabel.text = String(correct) + "/" + String(correctionArray.count)
            
            markLabel.textAlignment = .center
            
            markLabel.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
            
            view.addSubview(markLabel)
            
            let percentageLabel = UILabel(frame: CGRect(x: 0, y: 315, width: view.frame.width/2, height: 40))
            
            percentageLabel.textColor = UIColor.black
            
            percentageLabel.textAlignment = .center
            
            percentageLabel.text = String(Int(Double(correct)/Double(correctionArray.count) * Double(100)))+"%"
            
            percentageLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            
            view.addSubview(percentageLabel)
            
            let dataImageView = UIImageView(frame: CGRect(x: view.frame.width/2, y: 230, width: view.frame.width/2, height: 160))
            
            dataImageView.image = UIImage(named: "🏆")
            
            dataImageView.contentMode = .scaleAspectFit
            
            view.addSubview(dataImageView)
            
            let pointsGained = UILabel(frame: CGRect(x: view.frame.width/2, y: 400, width: view.frame.width/2, height: 40))
            
            pointsGained.textColor = UIColor.black
            
            pointsGained.textAlignment = .center
            
            pointsGained.text = "+50 points"
            
            pointsGained.font = UIFont.systemFont(ofSize: 38, weight: .bold)
            
            view.addSubview(pointsGained)
            
            buttonSwitch = UIButton(frame: CGRect(x: view.frame.width/4 - 100, y: 380, width: 200, height: 54))
            
            buttonSwitch.setTitle("Details", for: [])
            
            buttonSwitch.titleLabel?.textAlignment = .center
            
            buttonSwitch.setTitleColor(UIColor.white, for: [])
            
            buttonSwitch.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .black)
            
            buttonSwitch.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.5647058824, blue: 0.9411764706, alpha: 1)
            
            buttonSwitch.layer.cornerRadius = 10
            
            buttonSwitch.layer.shadowColor = #colorLiteral(red: 0, green: 0.2509803922, blue: 0.5450980392, alpha: 1).cgColor
            
            buttonSwitch.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
            
            buttonSwitch.layer.shadowOpacity = 1.0
            
            buttonSwitch.layer.shadowRadius = 0.0
            
            buttonSwitch.layer.masksToBounds = false
            
            buttonSwitch.addTarget(self, action: #selector(self.btnSwitchDown), for: .touchDown)
            
            buttonSwitch.addTarget(self, action: #selector(self.btnSwitchUp), for: [.touchUpInside, .touchUpOutside])
            
            view.addSubview(buttonSwitch)
            
        } else {
            
            let type = types[n]
            
            /*for data in newQuestions[type]! {
             
             print("DATA", data, data.components(separatedBy: ","))
             
             questions = data.components(separatedBy: ",")
             
             }*/
            
            questions = newQuestions[type]!
            
            quizView.subviews.forEach({ $0.removeFromSuperview() })
            
            quizView.removeFromSuperview()
            
            quizView = UIView(frame: CGRect.null)
            
            questionLabel = UILabel(frame: CGRect.null)
            
            extraLabel = UILabel(frame: CGRect.null)
            
            questionView = UIView(frame: CGRect.null)
            
            ansField = UITextField(frame: CGRect.null)
            
            button1 = UIButton(frame: CGRect.null)
            
            button2 = UIButton(frame: CGRect.null)
            
            button3 = UIButton(frame: CGRect.null)
            
            button4 = UIButton(frame: CGRect.null)
            
            buttonSubmit = UIButton(frame: CGRect.null)
            
            buttonChange = UIButton(frame: CGRect.null)
            
            status = UILabel(frame: CGRect.null)
            
            questionLabel.clipsToBounds = true
            
            if (n < typeNumber) {
                
                if type == "TOF" {
                    
                    answers = []
                    
                    correctAnswer = []
                    
                    var d = -1
                    
                    for i in questions {
                        
                        d = d + 1
                        
                        questions[d] = i.components(separatedBy: "")[0]
                        
                        let arr = i.components(separatedBy: "")[1].components(separatedBy: ";")
                        
                        var ans = 0
                        
                        if arr[0] == "true" {
                            
                            ans = 1
                            
                        } else if arr[0] == "false" {
                            
                            ans = 0
                            
                        } else {
                            
                            print("ERROR - 339 - F - QUIZ")
                            
                        }
                        
                        correctAnswer.append(ans)
                        
                        print("TOF-", correctAnswer, questions)
                        
                    }
                    
                    initBooleanQuiz()
                    
                } else if type == "FTB" {
                    
                    answers = []
                    
                    correctAnswer = []
                    
                    var d = -1
                    
                    for i in questions {
                        
                        //FTB?Q.ans1 *2,3,4;1;true;false
                        
                        d = d + 1
                        
                        questions[d] = i.components(separatedBy: "")[0]
                        
                        var arr = i.components(separatedBy: "")[1].components(separatedBy: ";")
                        
                        answersForFTB.append(arr[1].components(separatedBy: ","))
                        
                        answers.append(arr[0].components(separatedBy: ","))
                        
                    }
                    
                    initFTBQuiz()
                    
                } else if type == "MCQ" {
                    
                    var d = -1
                    
                    for i in questions {
                        
                        d = d + 1
                        
                        var arr = i.components(separatedBy: "")[0].components(separatedBy: "")
                        
                        questions[d] = arr[0]
                        
                        arr.remove(at: 0)
                        
                        answers.append(arr)
                        
                        arr = i.components(separatedBy: "")[1].components(separatedBy: ";")
                        
                        var ans = 0
                        
                        if arr[0] == "A" {
                            
                            ans = 0
                            
                        } else if arr[0] == "B" {
                            
                            ans = 1
                            
                        } else if arr[0] == "C" {
                            
                            ans = 2
                            
                        } else if arr[0] == "D" {
                            
                            ans = 3
                            
                        } else {
                            
                            print("ERROR - 339 - QUIZ")
                            
                        }
                        
                        correctAnswer.append(ans)
                        
                    }
                    
                    initMCQuiz()
                    
                }
                
            } else {
                
                print("FE")
                
                createQR()
                
            }
            
            typeIndex = typeIndex + 1
            
        }
        
    }
    
    @objc func btnSwitchDown() {
        
        UIView.animate(withDuration: 0.01, animations: {
            
            self.buttonSwitch.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            
            self.buttonSwitch.frame.origin.y = self.buttonSwitch.frame.origin.y + 6
            
            })
        
    }
    
    @objc func btnSwitchUp() {
        
        UIView.animate(withDuration: 0.002, animations: {
            
            self.buttonSwitch.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
            
            self.buttonSwitch.frame.origin.y = self.buttonSwitch.frame.origin.y - 6
            
        })
        
    }
    
    func group2(n:Int) {
        
        let type = types[n]
        
        quizView.removeFromSuperview()
        
        quizView = UIView(frame: CGRect.null)
        
        if (n < typeNumber) {
            
            if type == "TOF" {
                
                initBooleanQuiz()
                
            } else if type == "MCQ" {
                
                var tempN = 0
                
                answers = Array(repeating: [], count: questions.count)
                
                let d = qArray.split(separator: ",")
                
                //questions
                
                for i in d {
                    
                    //questions[tempN] = String(d)
                    
                    tempN = tempN + 1
                }
                
                tempN = 0
                
                for i in questions {
                    
                    questions[tempN] = String(i.split(separator: "")[0])
                    
                    var dA = i.split(separator: "")[0].split(separator: "")
                    
                    dA.remove(at: 0)
                    
                    for V in dA {
                        
                        answers[tempN].append(String(V))
                        
                    }
                    
                    let dCA = i.split(separator: "")[1].split(separator: ";")
                    
                    for i in questions {
                        
                        correctAnswer.append(0)
                        
                    }
                    
                    for V in dCA {
                        
                        var Value = 0
                        
                        print(V.replacingOccurrences(of: " ", with: ""))
                        
                        if V == "A" {
                            
                            Value = 0
                            
                        } else if V == "B" {
                            
                            Value = 1
                            
                        } else if V == "C" {
                            
                            Value = 2
                            
                        } else if V == "C" {
                            
                            Value = 3
                            
                        } else {
                            
                            print("ERROR")
                            
                        }
                        
                        correctAnswer[tempN] = Value
                        
                    }
                    
                    tempN = tempN + 1
                    
                }
                
                print(answers)
                
                initMCQuiz()
                
            }
            
        } else {
            
            print("FE")
            
            createQR()
            
        }
        
        typeIndex = typeIndex + 1
        
    }
    
    func breakQuizData2(str: String) {
        
        videoPreviewLayer?.isHidden = true
        
        answers = []
        
        questions = []
        
        quizData = "NAME(#)ID"
        
        correctAnswer = []
        
        timeLimit = -1
        
        //type = -1
        
        //hasCalc = false
        
        print("\n\n\nGRABBED DATA\n\n\n")
        
        /// Mr. Dandachi^&^96582548^{-1,2,0}^&^*<init>*q1:what is 1+1^&^[]^&^[2]*<done>*
        
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
         
         let vc = storyboard.instantiateViewController(withIdentifier: "notes")
         
         self.present(vc, animated: false, completion: nil)*/
        
        quizData = String(str.components(separatedBy: "^{")[0]).replacingOccurrences(of: "^&^", with: "-")
        
        let arrayData = String(str.components(separatedBy: "^{")[1].components(separatedBy: "}^&^")[0]).components(separatedBy: ",")
        
        timeLimit = Int(arrayData[0])!
        
        //type = Int(arrayData[1])!
        
        if Int(arrayData[2])! == 1 {
            
            //hasCalc = true
            
        }
        
        print(quizData)
        
        //print(timeLimit, type, hasCalc)
        
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
        
        /*if type == 0 {
         
         initBooleanQuiz()
         
         } else if type == 1 {
         
         initMCQuiz()
         
         } else if type == 2 {
         
         initNQuiz()
         
         }*/
        
    }
    
    var quizView = UIView(frame: CGRect.null)
    
    var questionLabel = UILabel(frame: CGRect.null)
    
    var extraLabel = UILabel(frame: CGRect.null)
    
    var questionView = UIView(frame: CGRect.null)
    
    var ansField = UITextField(frame: CGRect.null)
    
    var button1 = UIButton(frame: CGRect.null)
    
    var button2 = UIButton(frame: CGRect.null)
    
    var button3 = UIButton(frame: CGRect.null)
    
    var button4 = UIButton(frame: CGRect.null)
    
    var buttonSubmit = UIButton(frame: CGRect.null)
    
    var buttonChange = UIButton(frame: CGRect.null)
    
    var status = UILabel(frame: CGRect.null)
    
    var qIndex = -1
    
    var correctionArray : [Bool] = []
    
    var run = false
    
    //True or False
    
    var qNumber = 1
    
    var MoveCard = UIPanGestureRecognizer()
    
    var MoveTrue = UIPanGestureRecognizer()
    
    var MoveFalse = UIPanGestureRecognizer()
    
    func initBooleanQuiz() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        qIndex = questions.count - 1
        
        quizView.frame = view.frame
        
        quizView.backgroundColor = UIColor.white
        
        view.addSubview(quizView)
        
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
        
        MoveCard = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        
        MoveTrue = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanTrue(recognizer:)))
        
        MoveFalse = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFalse(recognizer:)))
        
        questionLabel.isUserInteractionEnabled = true
        
        questionLabel.addGestureRecognizer(MoveCard)
        
        questionLabel.text = questions[qIndex]
        
        button1 = customButtonToF(frame: CGRect(x: 4 * view.frame.width / 5, y: 137, width: view.frame.width / 5 * 6, height: view.frame.height - 147))
        
        button1.isUserInteractionEnabled = true
        
        button1.addGestureRecognizer(MoveTrue)
        
        button1.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        
        button1.setTitle("True", for: [])
        
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 48, weight: .black)
        
        (button1 as! customButtonToF).val = true
        
        (button1 as! customButtonToF).w = view.frame.width
        
        button1.layer.cornerRadius = 10
        
        button1.setImage(UIImage(named: "✓"), for: [])
        
        //button1.frame = CGRect(x: 4 * view.frame.width / 5, y: 0, width: view.frame.width / 5 * 6, height: view.frame.height - 10)
        
        button1.addTarget(self, action: #selector(self.checkIfAnsIsTruePress), for: .touchUpInside)
        
        button2 = customButtonToF(frame: CGRect(x: -view.frame.width, y: 137, width: view.frame.width / 5 * 6, height: view.frame.height - 147))
        
        button2.isUserInteractionEnabled = true
        
        button2.addGestureRecognizer(MoveFalse)
        
        button2.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        button2.setTitle("False", for: [])
        
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 48, weight: .black)
        
        (button2 as! customButtonToF).val = false
        
        (button2 as! customButtonToF).w = view.frame.width
        
        button2.layer.cornerRadius = 10
        
        button2.setImage(UIImage(named: "✗"), for: [])
        
        button2.addTarget(self, action: #selector(self.checkIfAnsIsFalsePress), for: .touchUpInside)
        
        //button2.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width / 5 * 6, height: view.frame.height - 10)
        
        button1.layer.shadowColor = #colorLiteral(red: 0.3058823529, green: 0.5803921569, blue: 0.007843137255, alpha: 1).cgColor
        button1.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button1.layer.shadowOpacity = 1.0
        button1.layer.shadowRadius = 0.0
        button1.layer.masksToBounds = false
        
        button2.layer.shadowColor = #colorLiteral(red: 0.7058823529, green: 0, blue: 0.0862745098, alpha: 1).cgColor
        button2.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button2.layer.shadowOpacity = 1.0
        button2.layer.shadowRadius = 0.0
        button2.layer.masksToBounds = false
        
        button1.imageView?.contentMode = UIViewContentMode.scaleAspectFill;
        
        button2.imageView?.contentMode = UIViewContentMode.scaleAspectFill;
        
        questionLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        questionLabel.textAlignment = .center
        
        questionLabel.frame = CGRect(x: view.frame.width / 5 + 10, y: 63.5+0.195*view.frame.height, width: (view.frame.width * 3 / 5) - 20, height: view.frame.height * 0.61)
        
        questionLabel.text = questions[qIndex]
        
        questionLabel.numberOfLines = 0
        
        questionLabel.adjustsFontSizeToFitWidth = true
        
        questionLabel.minimumScaleFactor = 0.6
        
        questionLabel.textColor = UIColor.black
        
        questionLabel.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        
        questionLabel.layer.masksToBounds = true
        
        questionLabel.layer.cornerRadius = 20.0
        
        quizView.addSubview(tickPhoto)
        
        quizView.addSubview(status)
        
        //quizView.addSubview(status)
        
        guidanceLabel.text = "True or False"
        
        guidanceLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.heavy)
        
        guidanceLabel.textColor = UIColor.black
        
        guidanceLabel.textAlignment = .center
        
        guidanceLabel.frame = CGRect(x: 0, y: 37, width: view.frame.width, height: 100)
        
        view.bringSubview(toFront: guidanceLabel)
        
        quizView.addSubview(questionLabel)
        
        quizView.addSubview(button1)
        
        quizView.addSubview(button2)
        
        print(qIndex)
        
        if run == false {
            
            timePassForBool()
            
            run = true
        }
        
    }
    
    let minXToPerformAction : CGFloat = 200
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        
        questionLabel.center = CGPoint(x:questionLabel.center.x + translation.x, y:questionLabel.center.y)
        
        //button2.frame = CGRect(x:button2.frame.origin.x,y:button2.frame.origin.y,width:button2.frame.width + translation.x,height:button2.frame.height)
        
        //button1.frame = CGRect(x:button1.frame.origin.x + translation.x,y:button1.frame.origin.y,width:button1.frame.width - translation.x,height:button1.frame.height)
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        if view.center.x - questionLabel.center.x < 0 {
            
            button1.frame.origin.x = button1.frame.origin.x - translation.x
            
            button2.frame.origin.x = button2.frame.origin.x - translation.x/3
            
        } else if view.center.x - questionLabel.center.x > 0 {
            
            button2.frame.origin.x = button2.frame.origin.x - translation.x
            
            button1.frame.origin.x = button1.frame.origin.x - translation.x/3
            
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {
            
            if view.center.x - questionLabel.center.x < -minXToPerformAction {
                
                checkIfAnsIsTruePress()
                
            } else if view.center.x - questionLabel.center.x > minXToPerformAction {
                
                checkIfAnsIsFalsePress()
                
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.questionLabel.center.x = self.view.center.x
                
            })
            
            
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
    
    @IBAction func handlePanTrue(recognizer:UIPanGestureRecognizer) {
        
        if recognizer.state == .began {
            
            view.bringSubview(toFront: button1)
            
        }
        
        let translation = recognizer.translation(in: self.view)
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        if button1.frame.origin.x - 0.8 * self.view.frame.width > 0 {
            
            button1.center = CGPoint(x:button1.center.x + translation.x/5, y:button1.center.y)
            
        } else {
            
            questionLabel.center = CGPoint(x:questionLabel.center.x - translation.x/3, y:questionLabel.center.y)
            
            button1.center = CGPoint(x:button1.center.x + translation.x, y:button1.center.y)
            
            button2.center = CGPoint(x:button2.center.x + translation.x/3, y:button2.center.y)
            
        }
        
        if button1.center.x < view.center.x {
            
            button1.center.x = view.center.x
            
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {
            
            if button1.frame.origin.x - 0.8 * self.view.frame.width < -minXToPerformAction*2 {
                
                checkIfAnsIsTruePress()
                
            } else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.questionLabel.center.x = self.view.center.x
                    
                    self.button1.frame.origin.x = 0.8 * self.view.frame.width
                    
                    self.button2.frame.origin.x = -self.view.frame.width
                    
                })
                
            }
            
            
        }
        
    }
    
    @IBAction func handlePanFalse(recognizer:UIPanGestureRecognizer) {
        
        if recognizer.state == .began {
            
            view.bringSubview(toFront: button2)
            
        }
        
        let translation = recognizer.translation(in: self.view)
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        if button2.frame.origin.x + self.view.frame.width < 0 {
            
            button2.center = CGPoint(x:button2.center.x + translation.x/5, y:button2.center.y)
            
        } else {
            
            questionLabel.center = CGPoint(x:questionLabel.center.x - translation.x/3, y:questionLabel.center.y)
            
            button2.center = CGPoint(x:button2.center.x + translation.x, y:button2.center.y)
            
            button1.center = CGPoint(x:button1.center.x + translation.x/3, y:button1.center.y)
            
        }
        
        if button2.center.x > view.center.x {
            
            button2.center.x = view.center.x
            
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {
            
            if button2.frame.origin.x + self.view.frame.width > minXToPerformAction*2 {
                
                checkIfAnsIsFalsePress()
                
            } else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.questionLabel.center.x = self.view.center.x
                    
                    self.button1.frame.origin.x = 0.8 * self.view.frame.width
                    
                    self.button2.frame.origin.x = -self.view.frame.width
                    
                })
                
            }
            
            
        }
        
    }
    
    @objc func checkIfAnsIsTruePress() {
        
        view.bringSubview(toFront: button1)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            //self.questionView.transform = CGAffineTransform(rotationAngle: 0)
            
            self.button1.frame.origin.x = -200
            
            self.button2.frame.origin.x = -self.view.frame.width / 5 * 6
            
        }) { (Bool) in
            
            self.checkIfAnsIsTrue()
            
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                
                self.button1.frame.origin.x = 0.8 * self.view.frame.width
                
                self.button2.frame.origin.x = -self.view.frame.width
                
                self.questionLabel.center.x = self.view.center.x
                
            })
            
        }
        
    }
    
    @objc func checkIfAnsIsFalsePress() {
        
        view.bringSubview(toFront: button2)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.button1.frame.origin.x = self.view.frame.width
            
            self.button2.frame.origin.x = 0
            
        }) { (Bool) in
            
            self.checkIfAnsIsFalse()
            
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                
                self.button1.frame.origin.x = 0.8 * self.view.frame.width
                
                self.button2.frame.origin.x = -self.view.frame.width
                
                self.questionLabel.center.x = self.view.center.x
                
            })
            
        }
        
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
        
        qIndex = qIndex - 1
        
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
            
            button1.isHidden = true
            
            button2.isHidden = true
            
            quizView.removeFromSuperview()
            
            group(n: typeIndex)
            
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
    
    var sharedWidth : CGFloat = 0
    
    func initMCQuiz() {
        
        questionLabel = correctAlignmentLabel(frame: CGRect.null)
        
        print("SDDSDSD", questions)
        
        print("ANSANSANS", answers)
        
        print("correctAnswercorrectAnswer", correctAnswer)
        
        self.tabBarController?.tabBar.isHidden = true
        
        extraLabel.frame = CGRect(x: 0, y: 105, width: view.frame.width, height: 25)
        
        extraLabel.font = UIFont.systemFont(ofSize: 25)
        
        extraLabel.text = "Tap the correct answer from below"
        
        extraLabel.textAlignment = .center
        
        guidanceLabel.text = "Multiple Choice"
        
        guidanceLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.heavy)
        
        guidanceLabel.textColor = UIColor.black
        
        guidanceLabel.textAlignment = .center
        
        guidanceLabel.frame = CGRect(x: 0, y: 37, width: view.frame.width, height: 100)
        
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
        
        print("qIndex:", qIndex)
        
        quizView.frame = view.frame
        
        view.addSubview(quizView)
        
        questionLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        questionLabel.textAlignment = .center
        
        questionLabel.frame = CGRect(x: 5, y: 160, width: view.frame.width, height: view.frame.height - 480)
        
        questionLabel.text = questions[qIndex]
        
        questionLabel.numberOfLines = 0
        
        questionLabel.adjustsFontSizeToFitWidth = true
        
        questionLabel.minimumScaleFactor = 0.6
        
        button1.titleLabel?.textColor = UIColor.black
        
        button1.backgroundColor = UIColor.white
        
        optionA.text = answers[qIndex][0]
        
        sharedWidth = (view.frame.width - 125) / 2
        
        button1.frame = CGRect(x: 50, y: view.frame.height - 440, width: sharedWidth, height: 200)
        
        button1.layer.cornerRadius = 35
        
        button1.addTarget(self, action: #selector(self.checkIfAnsIs1), for: .touchUpInside)
        
        button2.backgroundColor = UIColor.white
        
        optionB.text = answers[qIndex][1]
        
        button2.addTarget(self, action: #selector(self.checkIfAnsIs2), for: .touchUpInside)
        
        button2.layer.cornerRadius = 35
        
        button2.frame = CGRect(x: 75 + sharedWidth, y: view.frame.height - 440, width: sharedWidth, height: 200)
        
        button3.backgroundColor = UIColor.white
        
        optionC.text = answers[qIndex][2]
        
        button3.addTarget(self, action: #selector(self.checkIfAnsIs3), for: .touchUpInside)
        
        button3.layer.cornerRadius = 35
        
        button3.frame = CGRect(x: 50, y: view.frame.height - 230, width: sharedWidth, height: 200)
        
        button4.backgroundColor = UIColor.white
        
        optionD.text = answers[qIndex][3]
        
        button4.addTarget(self, action: #selector(self.checkIfAnsIs4), for: .touchUpInside)
        
        button4.layer.cornerRadius = 35
        
        button4.frame = CGRect(x: 75 + sharedWidth, y: view.frame.height - 230, width: sharedWidth, height: 200)
        
        A = UILabel(frame: CGRect(x: button1.frame.origin.x, y: button1.frame.origin.y, width: 120, height: button1.frame.height))
        
        B = UILabel(frame: CGRect(x: button2.frame.origin.x, y: button2.frame.origin.y, width: 120, height: button2.frame.height))
        
        C = UILabel(frame: CGRect(x: button3.frame.origin.x, y: button3.frame.origin.y, width: 120, height: button3.frame.height))
        
        D = UILabel(frame: CGRect(x: button4.frame.origin.x, y: button4.frame.origin.y, width: 120, height: button4.frame.height))
        
        optionA.frame = CGRect(x: A.frame.origin.x + A.frame.width, y: A.frame.origin.y, width: button1.frame.width - A.frame.width - 5, height: A.frame.height)
        
        optionB.frame = CGRect(x: B.frame.origin.x + B.frame.width, y: B.frame.origin.y, width: button2.frame.width - B.frame.width - 5, height: B.frame.height)
        
        optionC.frame = CGRect(x: C.frame.origin.x + C.frame.width, y: C.frame.origin.y, width: button3.frame.width - C.frame.width - 5, height: C.frame.height)
        
        optionD.frame = CGRect(x: D.frame.origin.x + D.frame.width, y: D.frame.origin.y, width: button4.frame.width - D.frame.width - 5, height: D.frame.height)
        
        optionA.lineBreakMode = .byWordWrapping
        
        optionB.lineBreakMode = .byWordWrapping
        
        optionC.lineBreakMode = .byWordWrapping
        
        optionD.lineBreakMode = .byWordWrapping
        
        optionA.adjustsFontSizeToFitWidth = true
        
        optionB.adjustsFontSizeToFitWidth = true
        
        optionC.adjustsFontSizeToFitWidth = true
        
        optionD.adjustsFontSizeToFitWidth = true
        
        buttonSubmit.frame = CGRect(x: 75 + sharedWidth, y: view.frame.height - 440, width: sharedWidth, height: 200)
        
        buttonChange.frame = CGRect(x: 75 + sharedWidth, y: view.frame.height - 230, width: sharedWidth, height: 200)
        
        buttonChange.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
        
        buttonSubmit.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        
        buttonChange.setTitle("Change Answer", for: [])
        
        buttonSubmit.setTitle("Continue", for: [])
        
        buttonChange.titleLabel?.font = UIFont.systemFont(ofSize: 48, weight: .black)
        
        buttonSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 48, weight: .black)
        
        buttonChange.layer.cornerRadius = 35
        
        buttonSubmit.layer.cornerRadius = 35
        
        buttonChange.isHidden = true
        
        buttonSubmit.isHidden = true
        
        buttonChange.addTarget(self, action: #selector(self.resetMCQVals), for: .touchUpInside)
        
        buttonSubmit.addTarget(self, action: #selector(self.submitAns), for: .touchUpInside)
        
        A.text = "A"
        
        B.text = "B"
        
        C.text = "C"
        
        D.text = "D"
        
        A.textColor = UIColor.white
        
        B.textColor = UIColor.white
        
        C.textColor = UIColor.white
        
        D.textColor = UIColor.white
        
        A.textAlignment = .center
        
        B.textAlignment = .center
        
        C.textAlignment = .center
        
        D.textAlignment = .center
        
        A.font = UIFont.systemFont(ofSize: 72, weight: UIFont.Weight.black)
        
        B.font = UIFont.systemFont(ofSize: 72, weight: UIFont.Weight.black)
        
        C.font = UIFont.systemFont(ofSize: 72, weight: UIFont.Weight.black)
        
        D.font = UIFont.systemFont(ofSize: 72, weight: UIFont.Weight.black)
        
        button4.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
        
        button2.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.8901960784, blue: 0.7607843137, alpha: 1)
        
        button3.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        
        button1.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
        
        optionA.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.medium)
        
        optionB.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.medium)
        
        optionC.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.medium)
        
        optionD.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.medium)
        
        optionA.adjustsFontSizeToFitWidth = true
        
        optionA.minimumScaleFactor = 0.417
        
        optionA.numberOfLines = 0
        
        optionB.adjustsFontSizeToFitWidth = true
        
        optionB.minimumScaleFactor = 0.417
        
        optionB.numberOfLines = 0
        
        optionC.adjustsFontSizeToFitWidth = true
        
        optionC.minimumScaleFactor = 0.417
        
        optionC.numberOfLines = 0
        
        optionD.adjustsFontSizeToFitWidth = true
        
        optionD.minimumScaleFactor = 0.417
        
        optionD.numberOfLines = 0
        
        optionA.textColor = UIColor.white
        
        optionB.textColor = UIColor.white
        
        optionC.textColor = UIColor.white
        
        optionD.textColor = UIColor.white
        
        tickPhoto.isHidden = true
        
        tickPhoto.contentMode = .center
        
        view.bringSubview(toFront: guidanceLabel)
        
        quizView.addSubview(questionLabel)
        
        quizView.addSubview(tickPhoto)
        
        ///quizView.addSubview(status)
        
        quizView.addSubview(button1)
        
        quizView.addSubview(button2)
        
        quizView.addSubview(button3)
        
        quizView.addSubview(button4)
        
        quizView.addSubview(optionA)
        
        quizView.addSubview(optionB)
        
        quizView.addSubview(optionC)
        
        quizView.addSubview(optionD)
        
        quizView.addSubview(extraLabel)
        
        quizView.addSubview(A)
        
        quizView.addSubview(B)
        
        quizView.addSubview(C)
        
        quizView.addSubview(D)
        
        quizView.addSubview(buttonSubmit)
        
        quizView.addSubview(buttonChange)
        
        print(qIndex)
        
        //resetMCQVals()
        
        if run == false {
            
            ///timePassForMCQ()
            
            //CHANGED THIS
            
            run = true
        }
        
    }
    
    @objc func timePassForMCQ() {
        
        if !(status.text == "time left: ∞") {
            
            if status.text == "time left: 0" {
                
                correctionArray.insert(false, at: 0)
                
                resetMCQVals()
                
                updateMCQuestion()
                
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
    
    @objc func submitAns() {
        
        resetMCQVals()
        
        fullMCQCheck()
        
        mcqValue = -1
        
    }
    
    @objc func checkIfAnsIs1() {
        
            mcqValue = 0
            
            self.buttonChange.isHidden = false
            
            self.buttonSubmit.isHidden = false
            
            quizView.bringSubview(toFront: buttonChange)
            
            quizView.bringSubview(toFront: buttonSubmit)
            
            quizView.bringSubview(toFront: button1)
            
            quizView.bringSubview(toFront: A)
            
            quizView.bringSubview(toFront: optionA)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.button1.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: self.sharedWidth, height: 410)
                
                self.A.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: 120, height: 410)
                
                self.optionA.frame = CGRect(x: 170, y: self.view.frame.height - 440, width: self.sharedWidth - 125, height: 410)
                
                self.button1.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
                
                })
        
    }
    
    @objc func checkIfAnsIs2() {
        
            mcqValue = 1
            
            self.buttonChange.isHidden = false
            
            self.buttonSubmit.isHidden = false
            
            quizView.bringSubview(toFront: buttonChange)
            
            quizView.bringSubview(toFront: buttonSubmit)
            
            quizView.bringSubview(toFront: button2)
            
            quizView.bringSubview(toFront: B)
            
            quizView.bringSubview(toFront: optionB)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.button2.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: self.sharedWidth, height: 410)
                
                self.B.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: 120, height: 410)
                
                self.optionB.frame = CGRect(x: 170, y: self.view.frame.height - 440, width: self.sharedWidth - 125, height: 410)
                
                self.button2.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
                
            })
        
    }
    
    @objc func checkIfAnsIs3() {
        
            mcqValue = 2
            
            self.buttonChange.isHidden = false
            
            self.buttonSubmit.isHidden = false
            
            quizView.bringSubview(toFront: buttonChange)
            
            quizView.bringSubview(toFront: buttonSubmit)
            
            quizView.bringSubview(toFront: button3)
            
            quizView.bringSubview(toFront: C)
            
            quizView.bringSubview(toFront: optionC)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.button3.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: self.sharedWidth, height: 410)
                
                self.C.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: 120, height: 410)
                
                self.optionC.frame = CGRect(x: 170, y: self.view.frame.height - 440, width: self.sharedWidth - 125, height: 410)
                
                self.button3.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
                
            })
        
    }
    
    @objc func checkIfAnsIs4() {
        
            mcqValue = 3
            
            self.buttonChange.isHidden = false
            
            self.buttonSubmit.isHidden = false
            
            quizView.bringSubview(toFront: buttonChange)
            
            quizView.bringSubview(toFront: buttonSubmit)
            
            quizView.bringSubview(toFront: button4)
            
            quizView.bringSubview(toFront: D)
            
            quizView.bringSubview(toFront: optionD)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.button4.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: self.sharedWidth, height: 410)
                
                self.D.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: 120, height: 410)
                
                self.optionD.frame = CGRect(x: 170, y: self.view.frame.height - 440, width: self.sharedWidth - 125, height: 410)
                
                self.button4.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
                
            })
        
    }
    
    @objc func resetMCQVals() {
        
        print("S")
        
        buttonSubmit.isHidden = true
        
        buttonChange.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.button4.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
            
            self.button2.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.8901960784, blue: 0.7607843137, alpha: 1)
            
            self.button3.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
            
            self.button1.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            
            //self.optionA.text = self.answers[self.qIndex][0]
            
            self.button1.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: self.sharedWidth, height: 200)
            
            //self.optionB.text = self.answers[self.qIndex][1]
            
            self.button2.frame = CGRect(x: 75 + self.sharedWidth, y: self.view.frame.height - 440, width: self.sharedWidth, height: 200)
            
            //self.optionC.text = self.answers[self.qIndex][2]
            
            self.button3.frame = CGRect(x: 50, y: self.view.frame.height - 230, width: self.sharedWidth, height: 200)
            
            //self.optionD.text = self.answers[self.qIndex][3]
            
            self.button4.frame = CGRect(x: 75 + self.sharedWidth, y: self.view.frame.height - 230, width: self.sharedWidth, height: 200)
            
            self.A.frame = CGRect(x: 50, y: self.view.frame.height - 440, width: 120, height: 200)
            
            self.B.frame = CGRect(x: 75 + self.sharedWidth, y: self.view.frame.height - 440, width: 120, height: 200)
            
            self.C.frame = CGRect(x: 50, y: self.view.frame.height - 230, width: 120, height: 200)
            
            self.D.frame = CGRect(x: 75 + self.sharedWidth, y: self.view.frame.height - 230, width: 120, height: 200)
            
            self.optionA.frame = CGRect(x: 170, y: self.view.frame.height - 440, width: self.sharedWidth - 125, height: 200)
            
            self.optionB.frame = CGRect(x: self.sharedWidth + 195, y: self.view.frame.height - 440, width: self.sharedWidth - 125, height: 200)
            
            self.optionC.frame = CGRect(x: 170, y: self.view.frame.height - 230, width: self.sharedWidth - 125, height: 200)
            
            self.optionD.frame = CGRect(x: self.sharedWidth + 195, y: self.view.frame.height - 230, width: self.sharedWidth - 125, height: 200)
            
            })
        
    }
    
    func fullMCQCheck() {
        
        print(qIndex)
        
        print("EVALMCQ", correctAnswer[qIndex], mcqValue)
        
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
            
            button1.isHidden = true
            
            button2.isHidden = true
            
            button3.isHidden = true
            
            button4.isHidden = true
            
            quizView.removeFromSuperview()
            
            group(n: typeIndex)
            
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
            
            group(n: typeIndex)
            
        } else {
            
            correct = 0
            
            for item in correctionArray {
                
                if item == true {
                    
                    correct = correct + 1
                    
                }
                
            }
            
            button1.isHidden = true
            
            button2.isHidden = true
            
            button3.isHidden = true
            
            button4.isHidden = true
            
        }
        
    }
    
    let layout: UICollectionViewFlowLayout = CenterAlignedCollectionViewFlowLayout()
    
    var myCollectionView:UICollectionView = UICollectionView(frame: CGRect.null, collectionViewLayout: UICollectionViewFlowLayout())
    
    var itemsInCollectionView : [String] = []
    
    func initFTBQuiz() {
        
        let minItemSpacing: CGFloat = 8
        let itemWidth: CGFloat = 160
        
        layout.sectionInset = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
        
        layout.estimatedItemSize = CGSize(width: 160, height: 68)
        
        myCollectionView = UICollectionView(frame: CGRect(x: 80, y: 310, width: view.frame.width - 160, height: view.frame.height - 428), collectionViewLayout: layout)
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(FTBCell.self, forCellWithReuseIdentifier: "FTBCollectionViewCell")
        myCollectionView.backgroundColor = UIColor.white
        
        questionLabel = UILabel(frame: CGRect.null)
        
        print("SDDSDSD", questions)
        
        print("ANSANSANS", answers)
        
        print("correctAnswercorrectAnswer", correctAnswer)
        
        self.tabBarController?.tabBar.isHidden = true
        
        extraLabel.frame = CGRect(x: 0, y: 115, width: view.frame.width, height: 25)
        
        extraLabel.font = UIFont.systemFont(ofSize: 25)
        
        extraLabel.text = "Choose the correct options from below to complete the sentence"
        
        extraLabel.textAlignment = .center
        
        guidanceLabel.text = "Fill In The Blanks"
        
        guidanceLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.heavy)
        
        guidanceLabel.textColor = UIColor.black
        
        guidanceLabel.textAlignment = .center
        
        guidanceLabel.frame = CGRect(x: 0, y: 37, width: view.frame.width, height: 100)
        
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
        
        print("qIndex:", qIndex)
        
        quizView.frame = view.frame
        
        view.addSubview(quizView)
        
        questionLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        questionLabel.textAlignment = .center
        
        questionLabel.frame = CGRect(x: 10, y: 160, width: view.frame.width-20, height: 150)
        
        questionLabel.text = questions[qIndex].replacingOccurrences(of: "*", with: "______________")
        
        blankCount = questions[qIndex].components(separatedBy:"*").count - 1
        
        var i = 0
        
        while i < blankCount {
            
            free.append(i)
            
            i = i + 1
            
        }
        
        print("BLANK COUNT:", blankCount, "; free:", free)
        
        questionLabel.numberOfLines = 0
        
        questionLabel.adjustsFontSizeToFitWidth = true
        
        questionLabel.minimumScaleFactor = 0.6
        
        buttonSubmit.frame = CGRect(x: view.frame.width/2 - 195, y: view.frame.height - 118, width: 390, height: 88)
        
        buttonSubmit.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        
        buttonSubmit.setTitle("Continue", for: [])
        
        buttonSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        
        buttonSubmit.layer.cornerRadius = 44
        
        buttonSubmit.isHidden = false //CHANGE THISSS
        
        buttonSubmit.addTarget(self, action: #selector(self.checkAnswerFTB), for: .touchUpInside)
        
        view.bringSubview(toFront: guidanceLabel)
        
        quizView.addSubview(questionLabel)
        
        quizView.addSubview(extraLabel)
        
        quizView.addSubview(buttonSubmit)
        
        print("______ FTB ______")
        
        print(qIndex)
        
        print(answers)
        
        print(answersForFTB)
        
        itemsInCollectionView = answers[qIndex] + answersForFTB[qIndex]
        
        itemsInCollectionView.shuffle()
        
        myCollectionView.reloadData()
        
        self.view.addSubview(myCollectionView)
        
        processChosenWords()
        
        if run == false {
            
            //CHANGED THIS
            
            run = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsInCollectionView.count
    }
    
    let colors = [#colorLiteral(red: 0.3137254902, green: 0.8901960784, blue: 0.7607843137, alpha: 1),#colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1),#colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1),#colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)]
    
    var selectedIndexes : [Int] = []
    
    var selectedIndexesPositions : [Int] = []
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FTBCollectionViewCell", for: indexPath as IndexPath) as! FTBCell
        
        cell.layer.borderWidth = 0
        
        cell.nameLabel.text = String(describing: itemsInCollectionView[indexPath.row])
        
        var cIndex = indexPath.row
        
        while cIndex > 3 {
            
            cIndex = cIndex - 4
            
        }
        
        if selectedIndexes.contains(indexPath.row) {
            
            cell.backgroundColor = colors[cIndex]
            
            cell.nameLabel.textColor = UIColor.white
            
        } else {
            
            cell.nameLabel.textColor = colors[cIndex]
            
            cell.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            
        }
        
        cell.layer.cornerRadius = 34
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.5,height: 4.0);
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 5.0
        
        return cell
        
    }
    
    var blankCount : Int = 0
    
    var free : [Int] = []
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = myCollectionView.cellForItem(at: indexPath) as! FTBCell
        
        let i = indexPath.row
        
        var cIndex = indexPath.row
        
        while cIndex > 3 {
            
            cIndex = cIndex - 4
            
        }
        
        if selectedIndexes.contains(i) {
            
            let temp = selectedIndexes.index(of: i)!
            
            free.append(selectedIndexesPositions[temp])
            
            selectedIndexes.remove(at: temp)
            
            selectedIndexesPositions.remove(at: temp)
            
            cell.nameLabel.textColor = colors[cIndex]
            
            cell.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            
        } else {
            
            if selectedIndexes.count > blankCount - 1 {
                
                let alert = UIAlertController(title: "Remove an item", message: "Each blank can fit one option, you picked " + String(describing: blankCount) + " options already, remove one to be able tp choose more", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                selectedIndexes.append(i)
                
                var low = -1
                
                print("ENTERING ALGORITHM:", free)
                
                for i in free {
                    
                    print(i)
                    
                    if low > i {
                    
                        low = i
                        
                    } else if low == -1 {
                        
                        low = i
                        
                    }
                    
                }
                
                print("LOW", low)
                
                free.remove(at: free.index(of: low)!)
                
                selectedIndexesPositions.append(low)
                
                cell.backgroundColor = colors[cIndex]
                
                cell.nameLabel.textColor = UIColor.white
                
            }
            
        }
        
        processChosenWords()
        
    }
    
    func processChosenWords() {
        
        var questionProcessed = [questions[qIndex]]
        
        questionProcessed = questionProcessed[0].components(separatedBy: "*")
        
        var questionProcessedWithAttributes : [NSMutableAttributedString] = []
        
        var finalQuestion = ""
        
        var finalAttributedQuestion = NSMutableAttributedString()
        
        let chosenAttribute = [[ NSAttributedStringKey.foregroundColor: colors[0], NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .bold) ],[ NSAttributedStringKey.foregroundColor: colors[1], NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .bold) ],[ NSAttributedStringKey.foregroundColor: colors[2], NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .bold) ],[ NSAttributedStringKey.foregroundColor: colors[3], NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .bold) ]]
        
        let questionAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .medium) ]
        
        let optionAttribute = [ NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0.886667192, blue: 1, alpha: 1), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .medium) ] as [NSAttributedStringKey : Any]
        
        for i in questionProcessed {
            
            questionProcessedWithAttributes.append(NSMutableAttributedString(string: i, attributes: questionAttribute))
            
        }
        
        for i in selectedIndexesPositions {
            
            print(i, ":", selectedIndexes[selectedIndexesPositions.index(of: i)!])
            
            let tempindex = selectedIndexes[selectedIndexesPositions.index(of: i)!]
            
            questionProcessedWithAttributes[i] = NSMutableAttributedString(string: questionProcessed[i], attributes: questionAttribute)
            
            questionProcessed[i] += String(itemsInCollectionView[tempindex] + "Ωª")
            
            var colorIndex = tempindex
            
            while colorIndex > 3 {
                
                colorIndex = colorIndex - 4
                
            }
                
            questionProcessedWithAttributes[i].append(NSMutableAttributedString(string: itemsInCollectionView[tempindex], attributes: chosenAttribute[colorIndex]))
            
        }
        
        for i in questionProcessed {
            
            if String(i.suffix(2)) == "Ωª" {
                
                finalQuestion += i.dropLast(2)
                
                finalAttributedQuestion.append(questionProcessedWithAttributes[questionProcessed.index(of: i)!])
                
            } else {
                
                finalQuestion += i + "*"
                
                finalAttributedQuestion.append(questionProcessedWithAttributes[questionProcessed.index(of: i)!])
                
                finalAttributedQuestion.append(NSMutableAttributedString(string: "______________", attributes: optionAttribute))
                
            }
            
        }
        
        finalQuestion.removeLast()
        
        let lastCharRange = NSMakeRange(finalAttributedQuestion.length - 14, 14)
        
        finalAttributedQuestion.deleteCharacters(in: lastCharRange)
        
        print("Final    :", finalQuestion)
        
        print("FinalAttr:", finalAttributedQuestion)
        
        questionLabel.attributedText = finalAttributedQuestion
        
    }
    
    @objc func checkAnswerFTB() {
        
        var correctAnswers = 0
        
        for i in selectedIndexesPositions {
            
            if answersForFTB[qIndex][i] == itemsInCollectionView[selectedIndexes[selectedIndexesPositions.index(of: i)!]] {
                
                correctAnswers += 1
                
            }
            
        }
        
        if correctAnswers == blankCount {
            
             correctionArray.insert(true, at: 0)
            
        } else {
            
            correctionArray.insert(false, at: 0)
            
        }
        
        qNumber = qNumber + 1
        
        qIndex = qIndex - 1
        
        if qIndex > -1 {
            
            questionLabel.text = questions[qIndex]
            
            itemsInCollectionView = answers[qIndex] + answersForFTB[qIndex]
            
            selectedIndexes = []
            
            selectedIndexesPositions = []
            
            blankCount = questions[qIndex].components(separatedBy:"*").count - 1
            
            free = []
            
            var i = 0
            
            while i < blankCount {
                
                free.append(i)
                
                i = i + 1
                
            }
            
            processChosenWords()
            
            myCollectionView.reloadData()
            
        } else {
            
            status.text = "time left: ∞"
            
            correct = 0
            
            for item in correctionArray {
                
                if item == true {
                    
                    correct = correct + 1
                    
                }
                
            }
            
            myCollectionView.removeFromSuperview()
            
            quizView.removeFromSuperview()
            
            buttonSubmit.removeFromSuperview()
            
            group(n: typeIndex)
            
        }
        
    }
    
    func labelWidth(text:String) -> CGFloat{
        // pass string ,font , LableWidth
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 68))
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = text
        label.sizeToFit()
        
        var w = label.frame.width
        
        if w < 160 {
            
            w = 140
            
        }
        
        return w + 80
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: labelWidth(text: String(describing: itemsInCollectionView[indexPath.row])), height: 68)
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

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

class FTBCell: UICollectionViewCell {
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        
    }
    
    func addViews(){
        
        backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        nameLabel.heightAnchor.constraint(equalToConstant: 68).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        
        addSubview(nameLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        // Copy each item to prevent "UICollectionViewFlowLayout has cached frame mismatch" warning
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        // Constants
        let leftPadding: CGFloat = 20
        let interItemSpacing: CGFloat = 50
        
        // Tracking values
        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
        var currentRow: Int = 0 // Tracks the current row
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute represents its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Register its origin.x in rowSizes for use later
                if rowSizes.count == 0 {
                    // Add to first row
                    rowSizes = [[leftMargin, 0]]
                } else {
                    // Append a new row
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
            
            // Add right-most x value for last item in the row
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }
        
        // At this point, all cells are left aligned
        // Reset tracking values and add extra left padding to center align entire row
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute is its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Need to bump it up by an appended margin
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin
                
                currentRow += 1
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
