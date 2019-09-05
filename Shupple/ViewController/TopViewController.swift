//
//  TopViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/08.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import Alamofire

class TopViewController: UIViewController, UIScrollViewDelegate {

    var scrollView = UIScrollView()
    let uid = UserDefaults.standard.object(forKey: "UID") as! String
    let url: URL = URL(string: "http://localhost:8080/users")!
    var opponent = User()
    // プロフィール画像
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentName: UILabel!
    @IBOutlet weak var opponentAge: UILabel!
    @IBOutlet weak var opponentResidence: UILabel!
    @IBOutlet weak var opponentJob: UILabel!
    @IBOutlet weak var opponentHobby: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        scrollView.delegate = self
        
        let image = UIImage(url: opponent.imageURL)
        opponentImage.image = image
        
        scrollView.addSubview(opponentName)
        scrollView.addSubview(opponentAge)
        scrollView.addSubview(opponentResidence)
        scrollView.addSubview(opponentJob)
        scrollView.addSubview(opponentHobby)
        scrollView.addSubview(opponentImage)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        view.addSubview(scrollView)
    }
    /**
     * scrollViewがスクロールされた時に呼ばれる
     * プロフィール画像を上部に固定する
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        opponentImage.frame = CGRect(x: 0, y: 0+scrollView.contentOffset.y,
                              width: view.frame.width, height: 350)
    }
    /**
     * APIのレスポンスを受け取った後のopponentを各パーツに詰める
     * TODO: それぞれのフィールドへ詰めていく
     */
    func convertOpponent(value: Data) {
        opponentName.text = opponent.nickName
        opponentAge.text = "\(String(opponent.age!)) 歳"
        opponentResidence.text = opponent.userInformation?.residence
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
