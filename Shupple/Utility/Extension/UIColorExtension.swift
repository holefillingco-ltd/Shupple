//
//  UIColorExtension.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/07.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
// UIColorをhexで指定できる拡張
// Ex.) UIColor(hex: "FF00FF")

import UIKit

extension UIColor {
    static let blueStartColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    static let blueEndColor = #colorLiteral(red: 0.2852321628, green: 0.938419044, blue: 0.9285692306, alpha: 1)
    static let pinkStartColor = #colorLiteral(red: 0.9662089944, green: 0, blue: 0.823137655, alpha: 1)
    static let pinkEndColor = #colorLiteral(red: 0.938419044, green: 0.6146818523, blue: 0.9140722291, alpha: 1)
    static let greenStartColor = #colorLiteral(red: 0.01324471092, green: 0.9139329232, blue: 0.07301861268, alpha: 1)
    static let greenEndColor = #colorLiteral(red: 0.7330715545, green: 1, blue: 0.6801393378, alpha: 1)
    
    convenience init(hex: String, alpha: CGFloat) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
}

