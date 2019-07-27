//
//  datasheetViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 2/24/18.
//  Copyright © 2018 Tareq El Dandachi. All rights reserved.
//

import UIKit

class datasheetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var graphImageView: UIImageView!
    
    @IBOutlet weak var xName: UITextField!
    @IBOutlet weak var yName: UITextField!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    
    @IBOutlet weak var x1: UITextField!
    @IBOutlet weak var y1: UITextField!
    
    @IBOutlet weak var x2: UITextField!
    @IBOutlet weak var y2: UITextField!
    
    @IBOutlet weak var x3: UITextField!
    @IBOutlet weak var y3: UITextField!
    
    @IBOutlet weak var x4: UITextField!
    @IBOutlet weak var y4: UITextField!
    
    @IBOutlet weak var x5: UITextField!
    @IBOutlet weak var y5: UITextField!
    
    @IBOutlet weak var x6: UITextField!
    @IBOutlet weak var y6: UITextField!
    
    @IBOutlet weak var x7: UITextField!
    @IBOutlet weak var y7: UITextField!
    
    @IBOutlet weak var x8: UITextField!
    @IBOutlet weak var y8: UITextField!
    
    @IBOutlet weak var x9: UITextField!
    @IBOutlet weak var y9: UITextField!
    
    @IBOutlet weak var x10: UITextField!
    @IBOutlet weak var y10: UITextField!
    
    @IBOutlet weak var x11: UITextField!
    @IBOutlet weak var y11: UITextField!
    
    let imageView1 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView2 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView3 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView4 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView5 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView6 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView7 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView8 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView9 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView10 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    let imageView11 = UIImageView(image: #imageLiteral(resourceName: "Plus"))
    
    var xi : Double = 0
    var yi : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xName.delegate = self
        yName.delegate = self
        
        x1.delegate = self
        y1.delegate = self
        
        x2.delegate = self
        y2.delegate = self
        
        x3.delegate = self
        y3.delegate = self
        
        x4.delegate = self
        y4.delegate = self
        
        x5.delegate = self
        y5.delegate = self
        
        x6.delegate = self
        y6.delegate = self
        
        x7.delegate = self
        y7.delegate = self
        
        x8.delegate = self
        y8.delegate = self
        
        x9.delegate = self
        y9.delegate = self
        
        x10.delegate = self
        y10.delegate = self
        
        x11.delegate = self
        y11.delegate = self
        
        xi = Double(graphImageView.frame.origin.x + 10)
        yi = Double(graphImageView.frame.origin.y + 355)
        
        print(xi,yi)
        
        view.addSubview(imageView1)
        
        view.addSubview(imageView2)
        
        view.addSubview(imageView3)
        
        view.addSubview(imageView4)
        
        view.addSubview(imageView5)
        
        view.addSubview(imageView6)
        
        view.addSubview(imageView7)
        
        view.addSubview(imageView8)
        
        view.addSubview(imageView9)
        
        view.addSubview(imageView10)
        
        view.addSubview(imageView11)
        
        imageView1.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView2.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView3.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView4.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView5.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView6.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView7.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView8.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView9.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView10.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        imageView11.frame = CGRect(x: -50, y: -50, width: 20, height: 20)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        refresh()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
        
    }
    
    func refresh() {
        
        if xName.text != "" {
        
            xLabel.text = xName.text
            
        } else {
            
            xLabel.text = "x-axis"
            
        }
        
        if yName.text != "" {
            
            yLabel.text = yName.text
            
        } else {
            
            yLabel.text = "y-axis"
            
        }
        
        var xArr = [Double(x1.text!),Double(x2.text!),Double(x3.text!),Double(x4.text!),Double(x5.text!),Double(x6.text!),Double(x7.text!),Double(x8.text!),Double(x9.text!),Double(x10.text!),Double(x11.text!)]
        
        var yArr = [Double(y1.text!),Double(y2.text!),Double(y3.text!),Double(y4.text!),Double(y5.text!),Double(y6.text!),Double(y7.text!),Double(y8.text!),Double(y9.text!),Double(y10.text!),Double(y11.text!)]
        
        var xArray : [Double] = []
        
        var yArray : [Double] = []
        
        for i in 0 ..< xArr.count {
            
            if xArr[i] != nil {
                
                if yArr[i] != nil {
                 
                    xArray.append(xArr[i]!)
                    
                    yArray.append(yArr[i]!)
                    
                }
                
            }
            
        }
        
        var xmax :Double = 0
        
        var ymax :Double = 0
        
        if xArray.isEmpty == false {
            
            if yArray.isEmpty == false {
                
                xmax = xArray.max()!*2.1
                
                ymax = yArray.max()!*1.2
                
                var i = 0
                
                var xPlot = 0.0
                
                var yPlot = 0.0
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView1.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 1
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView2.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 2
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView3.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
              
                }
                
                //
                
                i = 3
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView4.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 4
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView5.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 5
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView6.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 6
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView7.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 7
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView8.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 8
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView9.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 9
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView10.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                //
                
                i = 10
                
                if xArray.indices.contains(i) {
                    
                    xPlot = xi + (xArray[i] * (880-10) / xmax)
                    
                    yPlot = yi - (yArray[i] * (355) / ymax)
                    
                    print(xPlot, yPlot)
                    
                    imageView11.frame = CGRect(x: xPlot - 10, y: yPlot - 10, width: 20, height: 20)
                    
                }
                
                
                
            }
            
        }
        
        print(xArray, yArray, xmax, ymax)
        
    }

}
