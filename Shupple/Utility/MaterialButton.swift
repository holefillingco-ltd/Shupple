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
     * MaterialデザインSpringButton
     * superViewの中央に配置
     * superView: 親View
     * title: ボタンタイトル
     * y: 配置のy軸
     * startColor: グラデーション始め(濃い)
     * endColor: グラデーション終わり(薄い)
     */
    func setMaterialButton(superView: UIView, title: String, y: Int, startColor: UIColor, endColor: UIColor) -> SpringButton {
        let button = SpringButton(frame: CGRect(x: Int((superView.frame.width - 150)/2), y: y, width: 150, height: 50))
        let gradientLayer = CAGradientLayer()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = button.bounds.midY
        button.layer.shadowColor = startColor.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 10

        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.bounds.midY
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        button.animation = "wobble"
        
        return button
    }
    
}
