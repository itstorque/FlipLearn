//
//  alignment.swift
//  School
//
//  Created by Tareq El Dandachi on 6/4/18.
//  Copyright © 2018 Tareq El Dandachi. All rights reserved.
//

import Foundation

import UIKit

class correctAlignmentLabel: UILabel {
    
    override func drawText(in rect:CGRect) {
        
        guard let labelText = text else {
            
            return super.drawText(in: rect)
            
        }
        
        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedStringKey.font: font])
        
        var newRect = rect
        
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
            
        }
        
        super.drawText(in: newRect)
        
    }
    
}

class customButtonToF: UIButton {
    
    var val:Bool?
    
    var w: CGFloat = 100
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let value = val {
            
            if value == false {
                
                if let imageView = imageView, let titleLabel = titleLabel {
                    imageEdgeInsets = UIEdgeInsets(top: 5, left: self.frame.size.width-165, bottom: 5, right: 25)
                    
                    titleLabel.frame = CGRect(x: 10, y: 0, width: w, height: self.frame.size.height)
                    
                    titleLabel.textAlignment = .center
                    
                }
                
            } else {
                
                if let imageView = imageView, let titleLabel = titleLabel {
                    imageEdgeInsets = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: self.frame.size.width-195)
                    
                    titleLabel.frame = CGRect(x: w/5, y: 0, width: w, height: self.frame.size.height)
                    
                    titleLabel.textAlignment = .center
                    
                }
                
            }
            
        }
        
    }
    
}
