//
//  TopViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/08.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UIScrollViewDelegate {

    var header: UIView!
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // プロフィール画像
        header = UIView(frame: CGRect(x: 10, y: 20, width: view.frame.width - 10*2, height: 200))
        header.backgroundColor = UIColor.init(red: 157/255, green: 204/255, blue: 224/255, alpha: 1)
        scrollView.delegate = self
        scrollView.addSubview(header)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        view.addSubview(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.frame = CGRect(x: 0, y: 0+scrollView.contentOffset.y,
                              width: view.frame.width - 10*2, height: 200)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
