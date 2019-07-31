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

class FirstViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var AuthButton: UIButton!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!} }
    
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        AuthButton.addTarget(self,
                             action: #selector(self.AuthButtonTapped(sender:)),
                             for: .touchUpInside)
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

