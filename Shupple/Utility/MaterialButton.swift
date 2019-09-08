//
//  MaterialButton.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/08.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation
import UIKit

class MaterialUIButton {
    /**
     * 青ベースMaterialデザイン
     */
    func setBlueButton(superView: UIView, title: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: (superView.frame.width - 150)/2, y: 30, width: 150, height: 50))
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = button.bounds.midY
        button.layer.shadowColor = UIColor.startColor.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.bounds.midY
        gradientLayer.colors = [UIColor.startColor.cgColor, UIColor.endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        button.layer.insertSublayer(gradientLayer, at: 0)
        return button
    }
}
