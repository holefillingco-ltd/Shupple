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
    
    var indicator: NVActivityIndicatorView?
    var overView: UIView?

    public func start(view: UIView) {
        overView = UIView()
        overView!.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        overView!.backgroundColor = UIColor.blueEndColor
        overView!.alpha = 0.5
        view.addSubview(overView!)
        indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: NVActivityIndicatorType.lineScale, color: UIColor.white, padding: 0)
        indicator!.center = view.center
        view.addSubview(indicator!)
        indicator!.startAnimating()
    }
    
    public func stop(view: UIView) {
        overView!.removeFromSuperview()
        indicator!.stopAnimating()
    }
}
