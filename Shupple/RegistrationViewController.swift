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
    var selectedImage = UIImage()
    var imageValue = UIImage()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageValue = UIImage(data: data)!
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage(from: (user?.photoURL)!)
        form +++ Section("セクション名")
            <<< TextRow("Rowのタグ"){ row in
                row.title = "Rowのタイトル"
                row.placeholder = "プレースホルダー"
            }
            <<< ImageRow() {
                $0.title = "プロフィール画像"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                // TODO: エラーハンドリング追加
//                $0.value = UIImage(url: String(contentsOf: (user?.photoURL)!))
                $0.value = imageValue
                $0.clearAction = .yes(style: .destructive)
                $0.onChange { [unowned self] row in
                    self.selectedImage = row.value!
                }
            }
    }

}
