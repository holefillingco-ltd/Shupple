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
    let overView = UIView()

    init(view: UIView) {
        let overView = UIView()
        overView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        overView.backgroundColor = UIColor.black
        overView.alpha = 0.5
        view.addSubview(overView)
        self.indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white, padding: 0)
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
