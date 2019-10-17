//
//  FirstViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/07/28.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import TwitterKit

class FirstViewController: UIViewController, FUIAuthDelegate {
    
    
    @IBOutlet weak var topLogo: UIImageView!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var termsOfService: UISwitch!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var termOfServiceLabel: UIButton!
    
    @IBOutlet weak var topImageView: UIImageView!
    // Firebase認証
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!} }
    // UserDefaultのインスタンス
    let userDefaults = UserDefaults.standard
    let apiClient = APIClient()
    let indicator = Indicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        termsOfService.isOn = false
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
        ]
        // authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        setLayout()
        setAuthBtn()
    }
    
    private func setAuthBtn() {
        let btn = MaterialUIButton().setMaterialButton(superView: view, title: "認証", y: Int(view.frame.height - 100), startColor: .blueStartColor, endColor: .blueEndColor)
        btn.addTarget(self, action: #selector(self.AuthButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(btn)
        view.bringSubviewToFront(btn)
    }

    private func twitterAuthProvider() -> FUIAuthProvider? {
        let buttonColor = UIColor(red: 71.0/255.0, green: 154.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        return FUIOAuth(authUI: self.authUI,
                        providerID: "twitter.com",
                        buttonLabelText: "Sign in with Twitter",
                        shortName: "Twitter",
                        buttonColor: buttonColor,
                        iconImage: UIImage(named: "twtlogo")!.scaleImage(scaleSize: 0.09),
                        scopes: ["user.readwrite"],
                        customParameters: ["prompt" : "consent"],
                        loginHintKey: nil)
    }
    
    @objc func AuthButtonTapped(sender: AnyObject) {
        if termsOfService.isOn {
            let authViewController = self.authUI.authViewController()
            self.present(authViewController, animated: true, completion: nil)
        } else {
            present(AlertCustom().getAlertContrtoller(title: "エラー", message: "利用規約に同意が必要です。"), animated: true, completion: nil)
        }
    }
    /**
     * 認証成功後、遷移先VCを決定する
     */
    func selectNextVC(isRegistered: Bool) {
        if isRegistered {
            self.performSegue(withIdentifier: "registeredPattern", sender: self)
        } else {
            self.performSegue(withIdentifier: "toRegistrationView", sender: self)
        }
    }
    
    public func authUI(
        _ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?
    ) {
        // 認証に成功した場合
        if error == nil {
            let uid = authUI.auth?.currentUser?.uid
            apiClient.requestIsRegistered(uid: uid!, view: view, indicator: indicator, selectNextVC: selectNextVC, errorAlert: erroAlert)
        }
    }
    private func erroAlert() {
        present(AlertCustom().getAlertContrtoller(title: "エラー", message: "予期せぬエラーが発生しました。"), animated: true, completion: nil)
    }
    
    private func setLayout() {
        var topLogoRect = topLogo.frame
        topLogoRect.origin.x = (view.frame.width - topLogoRect.size.width)/2
        topLogo.frame = topLogoRect
        var topTitleRect = topTitle.frame
        topTitleRect.origin.x = (view.frame.width - topTitleRect.size.width)/2
        topTitle.frame = topTitleRect
        var termsOfServiceRect = termsOfService.frame
        termsOfServiceRect.origin.x = (view.frame.width - termsOfServiceRect.size.width)/2
        termsOfService.frame = termsOfServiceRect
        var termLabelRecct = termLabel.frame
        termLabelRecct.origin.x = (view.frame.width - termLabelRecct.size.width)/2
        termLabel.frame = termLabelRecct
        var termOfServiceLabelRect = termOfServiceLabel.frame
        termOfServiceLabelRect.origin.x = (view.frame.width - termOfServiceLabelRect.size.width)/2
        termOfServiceLabel.frame = termOfServiceLabelRect
    }
}
