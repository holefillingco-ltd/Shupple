//
//  TopViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/08.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UIScrollViewDelegate {

    var scrollView = UIScrollView()
    // プロフィール画像
    @IBOutlet weak var header: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        header.backgroundColor = UIColor.init(red: 157/255, green: 204/255,
                                              blue: 224/255, alpha: 1)
        scrollView.delegate = self
        scrollView.addSubview(header)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        view.addSubview(scrollView)
    }
    /*
     * scrollViewがスクロールされた時に呼ばれる
     * プロフィール画像を上部に固定する
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.frame = CGRect(x: 0, y: 0+scrollView.contentOffset.y,
                              width: view.frame.width, height: 300)
    }
    /*
     * APIで取得した相手の情報を各パーツに表示する
     */
    func setOppoent(opponent: Profile) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
