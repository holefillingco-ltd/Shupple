//
//  RegistrationViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/01.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import FirebaseAuth

class RegistrationViewController: FormViewController {
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("セクション名")
            <<< TextRow("Rowのタグ"){ row in
                row.title = "Rowのタイトル"
                row.placeholder = "プレースホルダー"
            }
            <<< ImageRow() {
                $0.title = "プロフィール画像"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                // TODO: エラーハンドリング追加
                $0.value = try! UIImage(url: String(contentsOf: (user?.photoURL)!))
                $0.clearAction = .yes(style: .destructive)

            }
    }

}
