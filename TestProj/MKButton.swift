//
//  MKButton.swift
//  TestProj
//
//  Created by MAHEEP on 10/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import UIKit

@IBDesignable

class MKButton: UIButton {
    
    func selectedBackGroundColor() {
        self.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        self.setTitleColor(selectedTitleColor, for: .normal)
    }
    
    func defaultBackgroundColor() {
        self.backgroundColor = UIColor.lightGray
        self.setTitleColor(normalTitleborderColor, for: .normal)
    }
    
    @IBInspectable var borderColor : UIColor?
    
    @IBInspectable var selectedTitleColor : UIColor?
    
    @IBInspectable var normalTitleborderColor : UIColor?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
    }
    
}

