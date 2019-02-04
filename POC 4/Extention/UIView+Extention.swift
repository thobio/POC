//
//  UIView+Extention.swift
//  POC 4
//
//  Created by Thobio on 23/01/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit

extension UIView {
    
    func createViewBackground() {
        layer.cornerRadius = 20.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

extension UIImageView {
    func imageViewRoundView(){
        layer.cornerRadius = self.layer.bounds.size.width/2
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4.0
        layer.masksToBounds = true
    }
}
