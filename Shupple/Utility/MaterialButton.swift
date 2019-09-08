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
     * MaterialデザインのUIButtonを返す
     */
    func setButton(superView: UIView, contentView: UIView) -> UIButton {
        let rgba = UIColor(hex: "b6dae3")
        let button = UIButton(frame: CGRect(x: 0, y: 50, width: superView.frame.width , height: 75.0))
        button.backgroundColor = rgba
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 30.0
        button.setTitle("登録", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        return button
    }
}
