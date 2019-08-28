//
//  Indicator.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/29.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
//  ロード中に表示するインジゲータークラス
//  Indicator(view) <- initialized
//  .start() <- アニメーション開始
//  .stop() <- アニメーション停止
import UIKit
import NVActivityIndicatorView

class Indicator {
    
    var indicator: NVActivityIndicatorView!

    init(view: UIView) {
        self.indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: NVActivityIndicatorType.lineSpinFadeLoader, color: UIColor.red, padding: 0)
        self.indicator.center = view.center
        view.addSubview(indicator)
    }
    
    public func start() {
        indicator.startAnimating()
    }
    
    public func stop() {
        indicator.stopAnimating()
    }
}
