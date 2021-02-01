//
//  Extensions.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 21.01.2021.
//

import UIKit
extension UIButton{
    func drawCorner(CGColor :CGColor = UIColor.black.cgColor, borderWidth: CGFloat = 1,cornerRadius: CGFloat) {
        let button = self
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = CGColor
        
    }
}
