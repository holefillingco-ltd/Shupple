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

    let currentUserUid = UserDefaults.standard.object(forKey: "UID") as! String
    let url: URL = URL(string: "http://localhost:8080/users")!
    let indicator = Indicator()
    let apiClient = APIClient()
    
    var scrollView = UIScrollView()
    var opponent = User()
    
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var hobbyTitle: UILabel!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var opponentName: UILabel!
    @IBOutlet weak var opponentAge: UILabel!
    @IBOutlet weak var opponentResidence: UILabel!
    @IBOutlet weak var opponentJob: UILabel!
    @IBOutlet weak var opponentHobby: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        setOpponentImage()
        setScrollView()
    }
    /**
     * imageView(opponentImage)のセットアップ
     */
    func setOpponentImage() {
        let image = UIImage(url: opponent.imageURL)
        opponentImage.contentMode = .scaleAspectFill
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 6
        opponentImage.image = image
    }
    /**
     * scrollViewのセットアップ
     */
    func setScrollView() {
        scrollView.addSubview(jobTitle)
        scrollView.addSubview(hobbyTitle)
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
                              width: view.frame.width, height: 300)
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
