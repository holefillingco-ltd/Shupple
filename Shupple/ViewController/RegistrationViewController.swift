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
import Alamofire
/*
 * TODO: APIを叩く処理
 */
class RegistrationViewController: FormViewController {
    
    // ログインユーザー
    let USER = Auth.auth().currentUser
    let prefectures = Prefecture.allPrefectures
    let jobs = Job.allJob
    let personalitys = Personality.allPersonality
    let ages = ["18~20", "20~25", "25~30", "30~35", "指定無し"]
    let sexes = Sex.allSex
    let encoder = JSONEncoder()
    let userDefaults = UserDefaults.standard
    
    var selectedImage = UIImage()
    var pView = UIView()
    var postUser = PostUser()
    

    /*
     * downloadImageで使用
     */
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    /*
     * URLからプロフィール画像をダウンロードする
     */
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
        self.navigationItem.hidesBackButton = true
        downloadImage(from: (USER?.photoURL)!)
    }
    /*
     * 画像プレビューを変更する
     * 引数に取ったUIImageをリサイズして表示
     * TODO: トリミング処理の関数を追加
     */
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
    /*
     * finButtonを押されたら呼ばれる
     */
    @objc func toRegistration(_ sender: UIButton) {
        requestRegistration()
        performSegue(withIdentifier: "toTopView", sender: nil)
    }
    /*
     * API Request
     * POST /users
     */
    private func requestRegistration() {
        let indicator = Indicator(view: self.view)
        indicator.start()
        let data = try! encoder.encode(postUser)
        let url: URL = URL(string: "http://localhost:8080/users")!
        var request = URLRequest(url: url)

        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                self.userDefaults.set(self.USER!.uid, forKey: "UID")
                print(self.userDefaults.object(forKey: "UID") as! String)
                indicator.stop()
            case .failure(let error):
                print(error)
            }
        }
    }
    /*
     * フォームのセット
     * TODO: finButtonの切り出し
     */
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
            <<< ImageRow(){ row in
                row.title = "プロフィール画像"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.value = selectedImage
                row.clearAction = .no
                row.onChange { [unowned self] row in
                    self.selectedImage = row.value!
                    self.changePV(image: self.selectedImage)
                }
            }
            <<< TextRow("nickName"){ row in
                row.title = "ニックネーム"
                row.value = USER?.displayName
                row.onChange{ row in
                    self.postUser.nickName = row.value!
                }
            }
            <<< DateRow("birth"){ row in
                row.title = "生年月日"
                row.onChange{ row in
                    self.postUser.setBirth(birth: row.value!)
                }
            }
            <<< SegmentedRow<String>("sex"){ row in
                row.options = sexes
                row.title = "性別"
                row.value = "男性"
                row.onChange{ row in
                    self.postUser.setSex(sex: row.value!)
                }
            }
            <<< TextRow("hobby"){ row in
                row.title = "趣味"
                row.placeholder = "Ex.) サッカー"
                row.onChange{ row in
                    self.postUser.hobby = row.value!
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "居住地"
                row.options = prefectures
                row.onChange{ row in 
                    self.postUser.setResidence(residence: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "職業"
                row.options = jobs
                row.onChange{ row in
                    self.postUser.setJob(job: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "性格"
                row.options = personalitys
                row.onChange{ row in 
                    self.postUser.setPersonality(personality: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in 
                row.title = "お相手の年齢"
                row.options = ages
                row.onChange{ row in
                    self.postUser.setOpponentAge(opponentAgeRange: row.value!)
                }
            }
        +++ Section() { row in
            row.footer = {
                let footer = HeaderFooterView<UIView>(.callback({
                    let fView = UIView(frame: CGRect(x: 0, y: 0,
                                                      width: self.view.frame.width,
                                                      height: 300))
                    let finButton = self.setFinButton(fView: fView)
                    fView.addSubview(finButton)
                    return fView
                }))
                return footer
            }()
        }
        postUser.nickName = (USER?.displayName)!
        postUser.uid = (USER?.uid)!
    }
    /*
     * finButton(submit)を返す
     */
    func setFinButton(fView: UIView) -> UIButton {
        let rgba = UIColor(hex: "b6dae3")
        let finButton = UIButton(frame: CGRect(x: 0, y: 50, width: self.view.frame.width , height: fView.frame.height / 4))
        finButton.backgroundColor = rgba
        finButton.layer.borderWidth = 0.5
        finButton.layer.borderColor = UIColor.black.cgColor
        finButton.layer.cornerRadius = 30.0
        finButton.setTitle("登録", for: UIControl.State.normal)
        finButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        finButton.layer.shadowOpacity = 0.5
        finButton.layer.shadowRadius = 12
        finButton.layer.shadowColor = UIColor.black.cgColor
        finButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        finButton.addTarget(self,
                            action: #selector(self.toRegistration(_:)),
                            for: UIControl.Event.touchUpInside)
        return finButton
    }
    /*
     * UserDefaultにUIDを保存
     */
    func setUIDToUserDefault() {
    }
}
