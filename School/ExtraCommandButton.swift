//
//  ExtraCommandButton.swift
//  School
//
//  Created by Tareq El Dandachi on 5/13/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.

import UIKit

/// UIButton subclass that draws a rounded rectangle in its background.

open class ExtraCommandButton: UIButton {
    
    // MARK: Public interface
    
    /// Color of the background rectangle
    open var rectColor: UIColor = UIColor(red:1, green:1, blue:1, alpha:1.0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    /// Color of the title text
    open var titleTextColor: UIColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
    
    // MARK: Overrides
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
        setTitleColor(titleTextColor, for: UIControlState() )
    }
    
    // MARK: Private
    
    fileprivate var roundRectLayer: CAShapeLayer?
    
    fileprivate func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = rectColor.cgColor
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.roundRectLayer = shapeLayer
    }
}
