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
    let materialButton = MaterialUIButton()
    
    var scrollView = UIScrollView()
    var opponentContentView = UIView()
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
        
        setScrollView()
        setOpponentImage()
        setButton()
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
        opponentContentView.addSubview(opponentName)
        opponentContentView.addSubview(opponentAge)
        opponentContentView.addSubview(opponentResidence)
        opponentContentView.addSubview(opponentJob)
        opponentContentView.addSubview(opponentHobby)
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
    func convertOpponent(value: Data) {
        opponentName.text = opponent.nickName
        opponentAge.text = "\(String(opponent.age!)) 歳"
        opponentResidence.text = opponent.userInformation?.residence
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /**
     * finButtonを押されたら呼ばれる
     */
    @objc func requestRegistration(_ sender: UIButton) {
        opponent = apiClient.requestGetOpponen(uid: currentUserUid, view: view, indicator: indicator)!
    }
    
    func setButton() {
        let getOpponentBtn = UIButton(type: .system)
        getOpponentBtn.frame = CGRect(x: 200, y: 550, width: 150, height: 50)
        getOpponentBtn.setTitle("Tap here!", for: .normal)
        getOpponentBtn.setTitleColor(UIColor.white, for: .normal)
        getOpponentBtn.layer.cornerRadius = getOpponentBtn.bounds.midY
        getOpponentBtn.layer.shadowColor = UIColor.startColor.cgColor
        getOpponentBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        getOpponentBtn.layer.shadowOpacity = 0.7
        getOpponentBtn.layer.shadowRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = getOpponentBtn.bounds
        gradientLayer.cornerRadius = getOpponentBtn.bounds.midY
        gradientLayer.colors = [UIColor.startColor.cgColor, UIColor.endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        getOpponentBtn.layer.insertSublayer(gradientLayer, at: 0)
        
        scrollView.addSubview(getOpponentBtn)
    }
}
