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
    
    @IBOutlet weak var AuthButton: UIButton!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!} }

    override func viewDidLoad() {
        super.viewDidLoad()
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            twitterAuthProvider()!
        ]
        // authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        AuthButton.addTarget(self,
                             action: #selector(self.AuthButtonTapped(sender:)),
                             for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print(user)
                self.performSegue(withIdentifier: "toTopView", sender: self)
            }
        }
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
        let authViewController = self.authUI.authViewController()
        self.present(authViewController,
                     animated: true,
                     completion: nil)
    }
    
    public func authUI(
        _ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?
    ) {
        // 認証に成功した場合
        if error == nil {
            self.performSegue(withIdentifier: "toTopView", sender: self)
        }
        
    }
    
    
}

