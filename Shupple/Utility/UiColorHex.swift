//
//  uiColorHex.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/07.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
// UIColorをhexで指定できる拡張
// Ex.) UIColor(hex: "FF00FF")

import UIKit

extension UIColor {
    static let startColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    static let endColor = #colorLiteral(red: 0.2852321628, green: 0.938419044, blue: 0.9285692306, alpha: 1)
    
    convenience init(hex: String, alpha: CGFloat) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}

