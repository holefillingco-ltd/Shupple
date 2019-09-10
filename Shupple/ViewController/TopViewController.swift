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
    let indicator = Indicator()
    let apiClient = APIClient()
    let materialButton = MaterialUIButton()
    let userDefaults = UserDefaults.standard
    
    var scrollView = UIScrollView()
    var opponentContentView = UIView()
    var opponent = User()
    var getOpponentBtn = SpringButton()
    
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var hobbyTitle: UILabel!
    @IBOutlet weak var personalityTitle: UILabel!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var opponentName: UILabel!
    @IBOutlet weak var opponentAge: UILabel!
    @IBOutlet weak var opponentResidence: UILabel!
    @IBOutlet weak var opponentJob: UILabel!
    @IBOutlet weak var opponentHobby: UILabel!
    @IBOutlet weak var opponentPersonality: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        setScrollView()
        setOpponentImage()
        setButton()
        userDefaults.register(defaults: ["OpponentUID":"default"])
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
        opponentContentView.addSubview(jobTitle)
        opponentContentView.addSubview(hobbyTitle)
        opponentContentView.addSubview(personalityTitle)
        opponentContentView.addSubview(opponentName)
        opponentContentView.addSubview(opponentAge)
        opponentContentView.addSubview(opponentResidence)
        opponentContentView.addSubview(opponentJob)
        opponentContentView.addSubview(opponentHobby)
        opponentContentView.addSubview(opponentPersonality)
        opponentContentView.addSubview(opponentImage)
        opponentContentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(opponentContentView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        view.addSubview(scrollView)
    }
    /**
     * scrollViewがスクロールされた時に呼ばれる
     * プロフィール画像を上部に固定する
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        opponentImage.frame = CGRect(x: 0, y: 0+scrollView.contentOffset.y, width: view.frame.width, height: 300)
    }
    /**
     * APIのレスポンスを受け取った後のopponentを各パーツに詰める
     * TODO: それぞれのフィールドへ詰めていく
     */
    private func convertOpponent() {
        opponentName.text = opponent.nickName
        opponentAge.text = "\(String(opponent.age!)) 歳"
        opponentResidence.text = opponent.userInformation?.residence
        opponentJob.text = opponent.userInformation?.job
        opponentHobby.text = opponent.userInformation?.hobby
        opponentPersonality.text = opponent.userInformation?.personality
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /**
     * getOpponentButtonを押されたら呼ばれる
     */
    @objc func requestGetOpponent(_ sender: UIButton) {
        getOpponentBtn.animate()
        opponent = apiClient.requestGetOpponent(userDefaults: userDefaults, uid: currentUserUid, view: view, indicator: indicator)
        convertOpponent()
        indicator.stop(view: view)
    }
    /**
     * MaterialButton
     */
    func setButton() {
        getOpponentBtn = materialButton.setMaterialButton(superView: view, title: "Shupple!!", y: 650, startColor: UIColor.pinkStartColor, endColor: UIColor.pinkEndColor)
        getOpponentBtn.addTarget(self, action: #selector(requestGetOpponent(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(getOpponentBtn)
    }
}
