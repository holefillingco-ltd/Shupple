//
//  TopViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/08.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth

class TopViewController: UIViewController, UIScrollViewDelegate {

    let currentUserUid = Auth.auth().currentUser?.uid
    let indicator = Indicator()
    let apiClient = APIClient()
    let materialButton = MaterialUIButton()
    let userDefaults = UserDefaults.standard
    let opponentUid = UserDefaults.standard.object(forKey: "OpponentUID") as? String
    
    var dateManager: DateManager?
    var scrollView = UIScrollView()
    var opponentContentView = UIView()
    var opponent = User()
    var getOpponentBtn = SpringButton()
    var chatBtn = SpringButton()
    var timer: Timer!
    
    @IBOutlet weak var timerView: UIImageView!
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var tmp: UILabel!
    
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
        setShuppleButton()
        setChatButton()
        setMatchingDate()
        requestGetUser()
    }
    
    /**
     * MatchingTimeが保存されている場合のみdateManagerをセット
     */
    func setMatchingDate() {
        if userDefaults.object(forKey: "MatchingTime") as? String != "default" {
            dateManager = DateManager(matchingDate: (userDefaults.object(forKey: "MatchingTime") as? Date)!)
        }
    }
    // タイマー
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // タイマー
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
        timer.fire()
    }
    // タイマー
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
        timer = nil
    }
    // タイマー
    @objc func updateCountdown(tm: Timer) {
        if userDefaults.object(forKey: "MatchingTime") as? String != "default" {
            let count = dateManager?.getMatchingEndTimeInterval()
            if count == "End" {
                // TODO: マッチングキャンセル
                requestCancelOpponent()
            }
            countdown.text = count
        } else {
            countdown.text = "マッチングしてみよう！"
            countdown.font = countdown.font.withSize(20)
            tmp.text = ""
        }
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
     * TODO: 綺麗にする
     *       順番の関係で最後にaddSubviewしてる
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
        view.addSubview(timerView)
        view.addSubview(countdown)
        view.addSubview(tmp)
    }
    /**
     * scrollViewがスクロールされた時に呼ばれる
     * プロフィール画像を上部に固定する
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        opponentImage.frame = CGRect(x: 0, y: 98+scrollView.contentOffset.y, width: view.frame.width, height: 300)
    }
    /**
     * APIのレスポンスを受け取った後のopponentを各パーツに詰める
     * TODO: それぞれのフィールドへ詰めていく
     */
    private func convertOpponent(opponent: User) {
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
        apiClient.requestGetOpponent(userDefaults: userDefaults, opponentUid: currentUserUid!, view: view, indicator: indicator, function: convertOpponent)
        dateManager = DateManager(matchingDate: Date())
    }
    /**
     * マッチング済みの場合相手のプロフィールを取得、表示する
     */
    func requestGetUser() {
        apiClient.requestIsMatched(userDefaults: userDefaults, uid: currentUserUid!, view: view, indicator: indicator, function: convertOpponent)
    }
    /**
     *
     */
    func requestCancelOpponent() {
        apiClient.requestCancelOpponent(userDefaults: userDefaults, uid: currentUserUid!, view: view, indicator: indicator)
    }
    /**
     * MaterialButton
     */
    func setShuppleButton() {
        getOpponentBtn = materialButton.setMaterialButton(superView: view, title: "Shupple!!", y: 750, startColor: UIColor.pinkStartColor, endColor: UIColor.pinkEndColor)
        getOpponentBtn.addTarget(self, action: #selector(requestGetOpponent(_:)), for: .touchUpInside)
        scrollView.addSubview(getOpponentBtn)
    }
    func setChatButton() {
        chatBtn = materialButton.setMaterialButton(superView: view, title: "Messagees", y: 850, startColor: UIColor.greenStartColor, endColor: UIColor.greenEndColor)
        chatBtn.addTarget(self, action: #selector(hoge(_:)), for: .touchUpInside)
        scrollView.addSubview(chatBtn)
    }
    /**
     * マッチング解除後(タイマーが0)各パーツをマッチング前に戻す
     */
    func cancelMatching() {
        opponentName.text = "マッチングしてみよう！"
        opponentAge.text = "no data"
        opponentResidence.text = "no data"
        opponentJob.text = "no data"
        opponentHobby.text = "no data"
        opponentPersonality.text = "no data"
        tmp.text = ""
        countdown.text = "マッチングしてみよう！"
    }
    /**
     * MEMO: チャット導線確認用（その内消す）
     */
    @objc func hoge(_ sender: UIButton) {
        performSegue(withIdentifier: "toChatView", sender: nil)
    }
}
