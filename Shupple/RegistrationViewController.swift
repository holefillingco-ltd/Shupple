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

    // downloadImageで使用
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
    
    // 画像プレビューを変更する
    // 引数に取ったUIImageをリサイズして表示
    // TODO: トリミング処理の関数を追加
    func changePV(image: UIImage) {
        let subviews = pView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
        imageView.layer.cornerRadius = 60
        pView.addSubview(imageView)
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
                    self.changePV(image: self.selectedImage)
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
            }
            <<< TextRow("nickName"){
                $0.title = "ニックネーム"
                $0.value = user?.displayName
            }
            <<< DateRow("birth"){
                $0.title = "生年月日"
            }
            <<< SegmentedRow<String>("sex"){
                $0.options = ["男性", "女性"]
                $0.title = "性別"
                $0.value = "男"
            }
        +++ Section("Fin") {
            $0.footer = {
                let footer = HeaderFooterView<UIView>(.callback({
                    let fView = UIView(frame: CGRect(x: 0, y: 0,
                                                      width: self.view.frame.width,
                                                      height: 300))
                    let rgba = UIColor(hex: "b6dae3")
                    // TODO: finButtonの切り出し
                    let finButton = UIButton(frame: CGRect(x: 0, y: 50, width: self.view.frame.width , height: fView.frame.height / 4))
                    finButton.backgroundColor = rgba
                    finButton.layer.borderWidth = 0.5
                    finButton.layer.borderColor = UIColor.black.cgColor
                    finButton.layer.cornerRadius = 12.0
                    finButton.setTitle("登録", for: UIControl.State.normal)
                    finButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    finButton.layer.shadowOpacity = 0.5
                    finButton.layer.shadowRadius = 12
                    finButton.layer.shadowColor = UIColor.black.cgColor
                    finButton.layer.shadowOffset = CGSize(width: 5, height: 5)
                    fView.addSubview(finButton)
                    return fView
                }))
                return footer
            }()
        }
    }
}
