//
//  TopViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/08.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI
import Floaty

class TopViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate {

    let currentUserUid = Auth.auth().currentUser?.uid
    let indicator = Indicator()
    let apiClient = APIClient()
    let materialButton = MaterialUIButton()
    let userDefaults = UserDefaults.standard
    var opponentUid = UserDefaults.standard.object(forKey: "OpponentUID") as? String
    
    @IBOutlet weak var opponentInformationStackView: UIStackView!
    var dateManager: DateManager?
    var scrollView = UIScrollView()
    var opponentContentView = UIView()
    var getOpponentBtn = SpringButton()
    var chatBtn = SpringButton()
    var anotherGetOpponentBtn = SpringButton()
    var anotherChatBtn = SpringButton()
    var timer: Timer!
    var countdownActive = false
    
    @IBOutlet weak var countdownView: UIView!
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
        
        setShuppleButton()
        setChatButton()
        setScrollView()
        setUpFloaty()
        requestIsMatched()
        setLayout()
        userDefaults.set(currentUserUid, forKey: "UID")
    }
    
    private func setLayout() {
        var countdownViewRect = countdownView.frame
        countdownViewRect.size.width = view.frame.width
        countdownView.frame = countdownViewRect
        var shadowViewRect = shadowView.frame
        shadowViewRect.size.width = view.frame.width
        shadowView.frame = shadowViewRect
        var countdownRect = countdown.frame
        countdownRect.origin.x = (view.frame.width - countdownRect.size.width)/2
        countdown.frame = countdownRect
    }
    // タイマー
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // タイマー
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.advanceCount), userInfo: nil, repeats: true)
//        timer.fire()
    }
    // 画面が閉じる直前にtimer削除
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
        timer = nil
    }
    // タイマーを停止し、再起動できるようにセット
    func invalidateAndReStartSetTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.advanceCount), userInfo: nil, repeats: true)
    }
    // タイマー
    // WARN: なんで動いてるか分からん
    @objc func advanceCount(tm: Timer) {
        if countdownActive == true {
            let count = dateManager?.getMatchingEndTimeInterval()
            countdown.font = countdown.font.withSize(38)
            setChatButton()
            setAnotherShuppleButton()
            if count == "End" {
                requestCancelOpponent()
                resetUIImageToNotMatching()
                countdownActive = false
                materialButton.changeTupIsEnabled(button: chatBtn, isEnabled: false,  startColor: UIColor.grayStartColor, endColor: UIColor.grayEndColor)
                countdown.text = "Shupple"
                countdown.font = countdown.font.withSize(30)
                tmp.text = ""
                setShuppleButton()
                setAnotherChatBtn()
                invalidateAndReStartSetTimer()
                return
            }
            countdown.text = count
            tmp.text = "TimeLimit"
        } else {
            countdown.text = "Shupple"
            countdown.font = countdown.font.withSize(30)
            tmp.text = ""
            setShuppleButton()
            setAnotherChatBtn()
        }
    }
    /**
     * imageView(opponentImage)のセットアップ
     */
    func setOpponentImage(opponent: User) {
        var imageURL = ""
        let tmp = opponent.imageURL ?? "https://schoolshop-lab.jp/wp-content/uploads/2018/11/240ec862387d03003cb4c41cd93cb0be.png"
        if opponent.imageURL != nil {
            imageURL = "https://new-classic.ninja/images/\(tmp)"
        } else {
            imageURL = tmp
        }
        let image = UIImage(url: imageURL)
        opponentImage.contentMode = .scaleAspectFill
        opponentImage.image = image
    }
    /**
     * scrollViewのセットアップ
     * TODO: 綺麗にする
     *       順番の関係で最後にaddSubviewしてる
     */
    func setScrollView() {
        opponentContentView.addSubview(opponentInformationStackView)
        opponentContentView.addSubview(opponentImage)
        opponentContentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(opponentContentView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 300)
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 6
        view.addSubview(scrollView)
        view.addSubview(countdownView)
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
    private func convertOpponentToUILabel(opponent: User) {
        opponentUid = opponent.uid
        opponentName.text = opponent.nickName
        opponentAge.text = "\(String(opponent.age!)) 歳"
        opponentResidence.text = opponent.userInformation?.residence
        opponentJob.text = opponent.userInformation?.job
        opponentHobby.text = opponent.userInformation?.hobby
        opponentPersonality.text = opponent.userInformation?.personality
        setOpponentImage(opponent: opponent)
    }
    
    func  dateManagerStart(matchingDate: Date)  {
        dateManager = DateManager.init(matchingDate: matchingDate)
        countdownActive = true
        timer.fire()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /**
     * getOpponentButtonを押されたら呼ばれる
     * 応急処置でDateManagerにDate()を渡している
     * 2回目起動以降(マッチング済み)は呼ばれないのが大前提
     */
    @objc func requestGetOpponent(_ sender: UIButton) {
        getOpponentBtn.animate()
        apiClient.requestGetOpponent(userDefaults: userDefaults, opponentUid: currentUserUid!, view: view, indicator: indicator, userConvertToUILabelFunc: convertOpponentToUILabel, dateManagerStartFunc: dateManagerStart, errorAlert: errorAlert, successAlert: successAlert)
    }
    
    func errorAlert() {
        present(AlertCustom().getAlertContrtoller(title: "エラー", message: "条件に合ったお相手が見つかりません🙇‍♂️少し時間をおいて下さい。"), animated: true, completion: nil)
    }
    func successAlert() {
        present(AlertCustom().getAlertContrtoller(title: "マッチング成功", message: "お相手が見つかりました！"), animated: true, completion: nil)
    }
    func unauthorizedSuccessAlert() {
        present(AlertCustom().getAlertContrtoller(title: "報告", message: "不適切なユーザーとして報告しました。"),
                animated: true, completion: nil)
    }
    /**
     * マッチング済みの場合相手のプロフィールを取得、表示する
     * マッチングしていない場合何も行わない
     */
    func requestIsMatched() {
        apiClient.requestIsMatched(userDefaults: userDefaults, uid: currentUserUid!, view: view, indicator: indicator, userConvertToUILabelFunc: convertOpponentToUILabel, dateManagerStartFunc: dateManagerStart, errorAlert: errorAlert)
    }
    /**
     * cancelAPIを叩き成功した場合
     */
    func requestCancelOpponent() {
        apiClient.requestCancelOpponent(userDefaults: userDefaults, uid: currentUserUid!, view: view, indicator: indicator, errorAlert: errorAlert)
        resetLabelToNotMatching()
    }
    /**
     * MaterialButton
     */
    func setShuppleButton() {
        getOpponentBtn.removeFromSuperview()
        anotherGetOpponentBtn.removeFromSuperview()
        getOpponentBtn = materialButton.setLeftMaterialButton(superView: view, title: "Shupple!!", y: 400, startColor: UIColor.pinkStartColor, endColor: UIColor.pinkEndColor)
        getOpponentBtn.addTarget(self, action: #selector(requestGetOpponent(_:)), for: .touchUpInside)
        opponentContentView.addSubview(getOpponentBtn)
        opponentContentView.sendSubviewToBack(getOpponentBtn)
    }
    func setChatButton() {
        chatBtn.removeFromSuperview()
        anotherChatBtn.removeFromSuperview()
        chatBtn = materialButton.setRightMaterialButton(superView: view, title: "メッセージ", y: 400, startColor: UIColor.greenStartColor, endColor: UIColor.greenEndColor)
        chatBtn.addTarget(self, action: #selector(toChatVC(_:)), for: .touchUpInside)
        opponentContentView.addSubview(chatBtn)
        opponentContentView.sendSubviewToBack(chatBtn)
    }
    func setAnotherShuppleButton() {
        anotherGetOpponentBtn.removeFromSuperview()
        getOpponentBtn.removeFromSuperview()
        anotherGetOpponentBtn = materialButton.setLeftMaterialButton(superView: view, title: "Shupple!!", y: 400, startColor: UIColor.grayStartColor, endColor: UIColor.grayEndColor)
        opponentContentView.addSubview(anotherGetOpponentBtn)
        opponentContentView.sendSubviewToBack(anotherGetOpponentBtn)
    }
    func setAnotherChatBtn() {
        anotherChatBtn.removeFromSuperview()
        chatBtn.removeFromSuperview()
        anotherChatBtn = materialButton.setRightMaterialButton(superView: view, title: "メッセージ", y: 400, startColor: UIColor.grayStartColor, endColor: UIColor.grayEndColor)
        opponentContentView.addSubview(anotherChatBtn)
        opponentContentView.sendSubviewToBack(anotherChatBtn)
    }
    /**
     * マッチング解除後(タイマーが0)各パーツをマッチング前に戻す
     */
    func resetLabelToNotMatching() {
        opponentName.text = "マッチングしてみよう！"
        opponentAge.text = "no data"
        opponentResidence.text = "no data"
        opponentJob.text = "no data"
        opponentHobby.text = "no data"
        opponentPersonality.text = "no data"
        tmp.text = ""
        countdown.text = "Shupple"
    }
    func resetUIImageToNotMatching() {
        let image = UIImage(named: "noImage")
        opponentImage.contentMode = .scaleAspectFill
        opponentImage.image = image
    }
    /**
     * MEMO: チャット導線確認用（その内消す）
     */
    @objc func toChatVC(_ sender: UIButton) {
        chatBtn.animate()
        performSegue(withIdentifier: "toChatView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatView" {
            let nextVC = segue.destination as! ChatViewController
            nextVC.opponentUid = self.opponentUid
        }
    }
    
    func setUpFloaty()  {
        let floaty = Floaty()
        floaty.buttonColor = countdownView.backgroundColor!
        floaty.addItem("ブロック", icon: UIImage(named: "cancel"), handler: {_ in
            self.unauthorizedBlock()
        })
        floaty.addItem("不適切なユーザーとして報告", icon: UIImage(named: "alarm"), handler: {_ in
            self.unauthorizedReport()
        })
        floaty.addItem("退会", icon: UIImage(named: "unsubscribe"), handler: {_ in
            self.unsubscribe()
        })
        floaty.addItem("お問い合わせ", icon: UIImage(named: "help"), handler: {_ in
            self.performSegue(withIdentifier: StaticContents.contactChat.segueIdentifirer, sender: nil)
        })
        floaty.addItem("アンケート", icon: UIImage(named: "questionnaire"), handler: {_ in
            self.performSegue(withIdentifier: "toQuestionView", sender: nil)
        })
        floaty.addItem("プロフィール編集", icon: UIImage(named: "user_edit")!, handler: {_ in
            self.performSegue(withIdentifier: StaticContents.updateUser.segueIdentifirer, sender: nil)
        })
        self.view.addSubview(floaty)
    }
    
    /********************************************************************
     *                     FloatyのボタンHandler                          *
     ********************************************************************/
    func hoge() {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "firstVC")
        self.present(nextView, animated: true, completion: nil)
    }
    
    func unsubscribe() {
        let alert = UIAlertController(title: "確認", message: "退会しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "退会", style: .default, handler: {(action: UIAlertAction!) in
            self.apiClient.requestSoftDeleteUser(uid: self.currentUserUid!, view: self.view, indicator: self.indicator, errorAlert: self.errorAlert, unsubscribe: self.hoge)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func unauthorizedReport() {
        if opponentUid == nil {
            let alert = UIAlertController(title: "確認", message: "不適切なユーザーとして報告しますか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "報告", style: .default, handler: {(action: UIAlertAction!) in
                self.apiClient.requestUnauthorized(uid: self.currentUserUid!, view: self.view, block: false, indicator: self.indicator, errorAlert: self.errorAlert, successAlert: self.unauthorizedSuccessAlert, reset: self.reset)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)

        } else {
            let alert = UIAlertController(title: "確認", message: "現在はマッチングしていません。", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func unauthorizedBlock() {
        if opponentUid == nil {
            let alert = UIAlertController(title: "確認", message: "不適切なユーザーとしてブロックしますか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "報告", style: .default, handler: {(action: UIAlertAction!) in
                self.apiClient.requestUnauthorized(uid: self.currentUserUid!, view: self.view, block: true, indicator: self.indicator, errorAlert: self.errorAlert, successAlert: self.unauthorizedSuccessAlert, reset: self.reset)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "確認", message: "現在はマッチングしていません。", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func reset() {
        resetLabelToNotMatching()
        resetUIImageToNotMatching()
    }
}
