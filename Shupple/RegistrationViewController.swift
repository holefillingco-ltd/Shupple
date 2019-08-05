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
    
    // ログインユーザー
    let user = Auth.auth().currentUser
    var selectedImage = UIImage()
    var pView = UIView()

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // URLからプロフィール画像をダウンロードする
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.selectedImage = UIImage(data: data)!
                self.setEureka()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage(from: (user?.photoURL)!)
    }
    
    // プロフィール画像を変更した時に呼ばれる
    // 画像プレビューを変更する
    func changePV(image: UIImage) {
        let subviews = pView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        pView.addSubview(UIImageView(image: image.scaleImage(scaleSize: 0.09)))
    }
    
    // フォームのセットアップ
    func setEureka() {
        form
            +++ Section() {
                $0.header = {
                    let header = HeaderFooterView<UIView>(.callback({
                        self.pView = UIView(frame: CGRect(x: 0, y: 0,
                                                        width: self.view.frame.width,
                                                        height: 300))
                        self.pView.addSubview(UIImageView(image: self.selectedImage))
                        return self.pView
                    }))
                    return header
                }()
            }
            +++ Section("Profile")
            <<< ImageRow(){
                $0.title = "プロフィール画像"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.value = selectedImage
                $0.clearAction = .no
                $0.onChange { [unowned self] row in
                    self.selectedImage = row.value!
                    self.changePV(image: self.selectedImage)
                }
            <<< TextRow("nickName"){ row in
                row.title = "ニックネーム"
                row.value = user?.displayName
            }
        }
    }
}
