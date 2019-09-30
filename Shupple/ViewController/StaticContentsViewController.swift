//
//  StaticContentsViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/11.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import MessageUI

class StaticContentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let staticContents = ["プロフィール編集", "お知らせ", "お問い合わせ", "退会"]

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
     * TODO: 他のセルが選択された時の動作
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case StaticContents.updateUser.rawValue:
            performSegue(withIdentifier: StaticContents.updateUser.segueIdentifirer, sender: nil)
        case StaticContents.notice.rawValue:
            performSegue(withIdentifier: StaticContents.notice.segueIdentifirer, sender: nil)
        case StaticContents.contact.rawValue:
            sendMail()
        case StaticContents.unsubscribe.rawValue:
            performSegue(withIdentifier: StaticContents.unsubscribe.segueIdentifirer, sender: nil)
        default:
            return
        }
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["diorclub8@gmail.com"]) // 宛先アドレス
            mail.setSubject("お問い合わせ") // 件名
            mail.setMessageBody("ここに本文が入ります。", isHTML: false) // 本文
            present(mail, animated: true, completion: nil)
        } else {
            present(AlertCustom().getAlertContrtoller(title: "エラー", message: "メールがご利用になれません。"), animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書き保存")
        case .sent:
            print("送信成功")
        default:
            print("送信失敗")
        }
        dismiss(animated: true, completion: nil)
    }
}
