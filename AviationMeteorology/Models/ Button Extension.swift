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
        let edgeInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = UIColor(named: "buttonSet")
        button.titleEdgeInsets = edgeInset
    }
}
