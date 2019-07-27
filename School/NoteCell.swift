//
//  NoteCell.swift
//  Fluid Notes
//
//  Created by Tareq El Dandachi on 8/4/16.
//  Copyright © 2016 Tareq El Dandachi. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    let label : UILabel
    
    let descLabel : UILabel
    
    var indexOfCell : Int
    
    var tagCircleLayer = CALayer()
    
    var itemTagLayer = CALayer()
    
    var rightActionLayer = CALayer()
    
    var leftActionLayer = CALayer()
    
    var seperatorLayer = CALayer()
    
    var discIndicator = UIImageView(image: #imageLiteral(resourceName: "Disclosure Indicator"))
    
    var LeftOnDragRelease = false, completeOnDragRelease = false
    
    var tickLabel: UILabel, deleteIcon: UIImageView
    
    var originalCenter = CGPoint()
    
    var notes : [String] = []
    
    var importNotes = UserDefaults.standard.array(forKey: "notes")
    
    var CanSwipe = true
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        label = UILabel(frame: CGRect.null)
        label.textColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        label.text = ""
        
        indexOfCell = Int()
        
        descLabel = UILabel(frame: CGRect.null)
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.numberOfLines = 2
        descLabel.backgroundColor = UIColor.clear
        descLabel.text = ""
        
        discIndicator.contentMode = .scaleAspectFit
        
        deleteIcon = UIImageView(image: #imageLiteral(resourceName: "Delete"))
        deleteIcon.contentMode = .scaleAspectFit
        
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.black
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.backgroundColor = UIColor.clear
            return label
        }
        
        func createCueDescLabel() -> UILabel {
            let descLabel = UILabel(frame: CGRect.null)
            descLabel.textColor = UIColor.black
            descLabel.font = UIFont.systemFont(ofSize: 12)
            descLabel.numberOfLines = 2
            descLabel.backgroundColor = UIColor.clear
            return descLabel
        }
        
        // tick and cross labels for context cues
        tickLabel = createCueLabel()
        tickLabel.textAlignment = .right
        
        tickLabel.text = "tag"
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        selectionStyle = .gray
        
        
        tagCircleLayer = CALayer(layer: layer)
        tagCircleLayer.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1).cgColor
        tagCircleLayer.isHidden = false ///CHANGE TO TRUE
        layer.insertSublayer(tagCircleLayer, at: 0)
        
        rightActionLayer = CALayer(layer: layer)
        rightActionLayer.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1).cgColor
        rightActionLayer.isHidden = false ///CHANGE TO TRUE
        layer.insertSublayer(rightActionLayer, at: 0)
        
        leftActionLayer = CALayer(layer: layer)
        leftActionLayer.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1).cgColor
        leftActionLayer.isHidden = false ///CHANGE TO TRUE
        layer.insertSublayer(leftActionLayer, at: 0)
        
        seperatorLayer = CALayer(layer: layer)
        seperatorLayer.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1).cgColor
        seperatorLayer.isHidden = false ///CHANGE TO TRUE
        layer.insertSublayer(seperatorLayer, at: 0)
        
        itemTagLayer = CALayer(layer: layer)
        itemTagLayer.backgroundColor = #colorLiteral(red: 0.8949507475, green: 0.1438436359, blue: 0.08480125666, alpha: 1).cgColor
        itemTagLayer.isHidden = true
        layer.insertSublayer(itemTagLayer, at: 0)
        
        addSubview(label)
        addSubview(descLabel)
        addSubview(tickLabel)
        addSubview(deleteIcon)
        addSubview(discIndicator)
        
        // add a pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(NoteCell.handlePan(_:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        self.label.highlightedTextColor = UIColor.white
        
        self.label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        if descLabel.textColor == UIColor.white {
            
            self.descLabel.highlightedTextColor = UIColor.black
            
        } else {
            
            self.descLabel.highlightedTextColor = UIColor.white
            
        }
        
        if UserDefaults.standard.bool(forKey: "showSeperators") {
            
            seperatorLayer.isHidden = false
            
        } else {
            
            seperatorLayer.isHidden = true
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    
    let kUICuesMargin: CGFloat = 15.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tagCircleLayer.frame = CGRect(x: 15, y: (bounds.height - 15) / 3, width: 15, height: 15)
        
        tagCircleLayer.cornerRadius = 15 / 2
        
        itemTagLayer.frame = bounds
        
        label.frame = CGRect(x: 20 * 2 , y: 0, width: bounds.size.width - 3 * kLabelLeftMargin - 20, height: bounds.size.height - (bounds.height - 15) / 3 )
        
        descLabel.frame = CGRect(x: 15 * 1.5 , y: bounds.height - 30 , width: bounds.size.width - 15 * 4 , height: 20)
        
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0, width: 50, height: bounds.size.height + 2)
        
        deleteIcon.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: (bounds.size.height - 15 * 1.5) / 2, width: 15 * 1.5, height: 15 * 1.5)
        
        rightActionLayer.frame = CGRect(x: bounds.size.width, y: 0, width: bounds.size.width*2, height: bounds.size.height)
        
        leftActionLayer.frame = CGRect(x: -10*bounds.size.width, y: 0, width: 10*bounds.size.width, height: bounds.size.height)
        
        seperatorLayer.frame = CGRect(x: 0, y: bounds.size.height - 1, width: bounds.size.width, height: 1)
        
        discIndicator.frame = CGRect(x: bounds.width - 15 * 2, y: (bounds.height - 15) / 2, width: 15, height: 15)
        
    }
    
    //MARK: - horizontal pan gesture methods
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
            
            let aCellIsSwiping = UserDefaults.standard.bool(forKey: "aCellIsSwiping")
            
            if aCellIsSwiping == false {
                
                UserDefaults.standard.set(true, forKey: "aCellIsSwiping")
                
                CanSwipe = true
                
            } else {
                
                CanSwipe = false
                
            }
            
        }
        // 2
        if recognizer.state == .changed {
            
            if CanSwipe == true {
            
                let translation = recognizer.translation(in: self)
                center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            
                LeftOnDragRelease = frame.origin.x < -frame.size.width / 4.0
                completeOnDragRelease = frame.origin.x > frame.size.width / 4.0
            
                let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 4.0)
                tickLabel.alpha = cueAlpha
                deleteIcon.alpha = cueAlpha
            
                tickLabel.textColor = completeOnDragRelease ? #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1) : #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 0.5)
            
            
                tickLabel.font = UIFont.boldSystemFont(ofSize: 24)
            
                deleteIcon.alpha = LeftOnDragRelease ? 1 : 0.5
                
            }
            
        }
        
        // 3
        if recognizer.state == .ended {
            
            /*if !((importNotes?.count)! > 0) {
                
                importNotes = []
                
            }
            
            notes = importNotes as! [String]*/
            
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            
            if LeftOnDragRelease {
                
                print("Enough Dragging")
                
                UserDefaults.standard.set(indexOfCell, forKey: "indexToDelete")
                
                UserDefaults.standard.set(true, forKey: "Delete?")
                
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                
            } else if completeOnDragRelease {
                
                UserDefaults.standard.set(indexOfCell, forKey: "indexToTag")
                
                UserDefaults.standard.set(true, forKey: "Tag?")
            
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                
            } else {
                
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                
            }
            
            if CanSwipe {
                
                UserDefaults.standard.set(false, forKey: "aCellIsSwiping")
                
            }
            
        }
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            
            let translation = panGestureRecognizer.translation(in: superview!)
            
            if fabs(translation.x) > fabs(translation.y) {
                
                return true
                
            }
            
            return false
            
        }
        
        return false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let bgColorView = UIView()
        
        bgColorView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        selectedBackgroundView = bgColorView
        
    }
    
}
