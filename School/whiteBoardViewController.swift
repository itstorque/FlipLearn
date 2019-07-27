//
//  whiteBoardViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 5/13/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.
//

import UIKit

class whiteBoardViewController: UIViewController {
    
    @IBOutlet weak var bg: UIView!
    
    @IBOutlet weak var switchMode: UIButton!
    
    @IBOutlet weak var clear: UIButton!
    
    var color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    
    var strokeWidth = CGFloat(7)
    
    let drawView = UIImageView(frame: CGRect.null)
    
    var isSwiping : Bool!
    
    var lastPoint:CGPoint!

    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var pinkButton: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var purpleButton: UIButton!
    
    @IBOutlet weak var orangeButton: UIButton!
    
    var globalColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clear.addTarget(self, action:#selector(self.clearDrawView), for: .touchUpInside)
        
        switchMode.addTarget(self, action:#selector(self.switchColor), for: .touchUpInside)
        
        drawView.frame = bg.frame
        
        view.addSubview(drawView)
        
        blueButton.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), for: [])
        
        pinkButton.setTitleColor(#colorLiteral(red: 1, green: 0, blue: 0.501960814, alpha: 1), for: [])
        
        redButton.setTitleColor(#colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1), for: [])
        
        greenButton.setTitleColor(#colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1), for: [])
        
        purpleButton.setTitleColor(#colorLiteral(red: 0.3294117647, green: 0, blue: 0.9215686275, alpha: 1), for: [])
        
        orangeButton.setTitleColor(#colorLiteral(red: 0.9346159697, green: 0.6284804344, blue: 0.1077284366, alpha: 1), for: [])
        
        resetColor()
        
        blueButton.setTitle("⚫︎", for: [])
        blueButton.setTitle("⚪︎", for: UIControlState.highlighted)
        
        blueButton.addTarget(self, action: #selector(self.blueColor), for: .touchUpInside)
        
        pinkButton.addTarget(self, action: #selector(self.pinkColor), for: .touchUpInside)
        
        redButton.addTarget(self, action: #selector(self.redColor), for: .touchUpInside)
        
        greenButton.addTarget(self, action: #selector(self.greenColor), for: .touchUpInside)
        
        purpleButton.addTarget(self, action: #selector(self.purpleColor), for: .touchUpInside)
        
        orangeButton.addTarget(self, action: #selector(self.orangeColor), for: .touchUpInside)
        
    }
    
    func resetColor() {
        
        blueButton.setTitle("⚪︎", for: [])
        blueButton.setTitle("⚫︎", for: UIControlState.highlighted)
        
        pinkButton.setTitle("⚪︎", for: [])
        pinkButton.setTitle("⚫︎", for: UIControlState.highlighted)
        
        redButton.setTitle("⚪︎", for: [])
        redButton.setTitle("⚫︎", for: UIControlState.highlighted)
        
        greenButton.setTitle("⚪︎", for: [])
        greenButton.setTitle("⚫︎", for: UIControlState.highlighted)
        
        purpleButton.setTitle("⚪︎", for: [])
        purpleButton.setTitle("⚫︎", for: UIControlState.highlighted)
        
        orangeButton.setTitle("⚪︎", for: [])
        orangeButton.setTitle("⚫︎", for: UIControlState.highlighted)
        
    }
    
    @objc func blueColor() {
        
        resetColor()
        
        blueButton.setTitle("⚫︎", for: [])
        blueButton.setTitle("⚪︎", for: UIControlState.highlighted)
        
        globalColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        
        switchColor()
        
        switchColor()
        
    }
    
    @objc func pinkColor() {
        
        resetColor()
        
        pinkButton.setTitle("⚫︎", for: [])
        pinkButton.setTitle("⚪︎", for: UIControlState.highlighted)
        
        globalColor = #colorLiteral(red: 1, green: 0, blue: 0.501960814, alpha: 1)
        
        switchColor()
        
        switchColor()
        
    }
    
    @objc func redColor() {
        
        resetColor()
        
        redButton.setTitle("⚫︎", for: [])
        redButton.setTitle("⚪︎", for: UIControlState.highlighted)
        
        globalColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
        
        switchColor()
        
        switchColor()
        
    }
    
    @objc func greenColor() {
        
        resetColor()
        
        greenButton.setTitle("⚫︎", for: [])
        greenButton.setTitle("⚪︎", for: UIControlState.highlighted)
        
        globalColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1)
        
        switchColor()
        
        switchColor()
        
    }
    
    @objc func purpleColor() {
        
        resetColor()
        
        purpleButton.setTitle("⚫︎", for: [])
        purpleButton.setTitle("⚪︎", for: UIControlState.highlighted)
        
        globalColor = #colorLiteral(red: 0.3294117647, green: 0, blue: 0.9215686275, alpha: 1)
        
        switchColor()
        
        switchColor()
        
    }
    
    @objc func orangeColor() {
        
        resetColor()
        
        orangeButton.setTitle("⚫︎", for: [])
        orangeButton.setTitle("⚪︎", for: UIControlState.highlighted)
        
        globalColor = #colorLiteral(red: 0.9346159697, green: 0.6284804344, blue: 0.1077284366, alpha: 1)
        
        switchColor()
        
        switchColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func switchColor() {
        
        if color == UIColor.white {
            
            color = globalColor
            
            strokeWidth = 7
            
            switchMode.setTitle("🖊Pen", for: [])
            
            blueButton.isHidden = false
            
            pinkButton.isHidden = false
            
            redButton.isHidden = false
            
            greenButton.isHidden = false
            
            purpleButton.isHidden = false
            
            orangeButton.isHidden = false
            
        } else {
            
            color = UIColor.white
            
            strokeWidth = 14
            
            switchMode.setTitle("✏️Eraser", for: [])
            
            blueButton.isHidden = true
            
            pinkButton.isHidden = true
            
            redButton.isHidden = true
            
            greenButton.isHidden = true
            
            purpleButton.isHidden = true
            
            orangeButton.isHidden = true
            
        }
        
    }
    
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
            
            UIGraphicsGetCurrentContext()?.setLineWidth(strokeWidth)
            
            UIGraphicsGetCurrentContext()?.setStrokeColor(color.cgColor)
            
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
            
            UIGraphicsGetCurrentContext()?.setLineWidth(strokeWidth)
            
            UIGraphicsGetCurrentContext()?.setStrokeColor(color.cgColor)
            
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            
            UIGraphicsGetCurrentContext()?.strokePath()
            
            self.drawView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
        }
        
    }
    
    @objc func clearDrawView() {
        
        self.drawView.image = nil
        
    }
    
}
