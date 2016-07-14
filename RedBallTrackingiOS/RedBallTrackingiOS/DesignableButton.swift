//
//  DesignableButton.swift
//  EGE
//
//  Created by Jordan R Wiker on 6/22/15.
//  Copyright (c) 2015 Wood & Wiker. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {
        
    @IBInspectable var borderWidth:CGFloat = 3.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var cornerRoundness:CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRoundness
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
