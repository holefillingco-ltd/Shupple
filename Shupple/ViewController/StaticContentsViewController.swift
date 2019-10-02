//
//  StaticContentsViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/11.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class StaticContentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let staticContents = ["プロフィール編集", "お知らせ", "メールでのお問い合わせ", "チャットでのお問い合わせ","退会"]
    let currentUserUid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     * セルの数を設定
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticContents.count
    }
    
    /**
     * セルに表示する値を設定
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "staticContents", for: indexPath)
        cell.textLabel!.text = staticContents[indexPath.row]
        return cell
    }
    
    /**
     * セルが選択された時の動作
     * TODO: アプリインストール時に戻す(userdefaultsとか)
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case StaticContents.updateUser.rawValue:
            performSegue(withIdentifier: StaticContents.updateUser.segueIdentifirer, sender: nil)
        case StaticContents.notice.rawValue:
            performSegue(withIdentifier: StaticContents.notice.segueIdentifirer, sender: nil)
        case StaticContents.contactEmail.rawValue:
            sendMail()
        case StaticContents.contactChat.rawValue:
            performSegue(withIdentifier: StaticContents.contactChat.segueIdentifirer, sender: nil)
        case StaticContents.unsubscribe.rawValue:
            unsubscribe()
        default:
            return
        }
    }
    
    func hoge() {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "firstVC")
        self.present(nextView, animated: true, completion: nil)
    }
    
    func unsubscribe() {
        let alert = UIAlertController(title: "確認", message: "退会しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "退会", style: .default, handler: {(action: UIAlertAction!) in
            APIClient().requestSoftDeleteUser(uid: self.currentUserUid!, view: self.view, indicator: Indicator(), errorAlert: self.errorAlert, unsubscribe: self.hoge)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func errorAlert() {
        present(AlertCustom().getAlertContrtoller(title: "エラー", message: ""), animated: true, completion: nil)
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["diorclub8@gmail.com"])
            mail.setSubject("お問い合わせ")
            mail.setMessageBody("ここに本文が入ります。", isHTML: false)
            present(mail, animated: true, completion: nil)
        } else {
            present(AlertCustom().getAlertContrtoller(title: "エラー", message: "メールがご利用になれません。"), animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            present(AlertCustom().getAlertContrtoller(title: "メール", message: "キャンセルしました。"), animated: true, completion: nil)
        case .saved:
            present(AlertCustom().getAlertContrtoller(title: "メール", message: "下書きを保存しました。"), animated: true, completion: nil)
        case .sent:
            present(AlertCustom().getAlertContrtoller(title: "メール", message: "送信完了しました。"), animated: true, completion: nil)
        default:
            present(AlertCustom().getAlertContrtoller(title: "メール", message: "送信に失敗しました。時間が経ってから再度お試行して下さい。"), animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
}
