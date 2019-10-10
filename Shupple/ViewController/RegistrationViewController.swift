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
    
    private let currentuser = Auth.auth().currentUser
    private let prefectures = Prefecture.allPrefectures
    private let jobs = Job.allJob
    private let personalitys = Personality.allPersonality
    private let ages = ["18~20", "20~25", "25~30", "30~35", "指定無し"]
    private let sexes = Sex.allSex
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    private let indicator = Indicator()
    private let apiClient = APIClient()
    private let materialUIButton = MaterialUIButton()
    
    private var finButton = SpringButton()
    private var selectedImage = UIImage()
    private var pView = UIView()
    private var postUser = PostUser()
    
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
        if currentuser?.photoURL != nil {
            downloadImage(from: (currentuser?.photoURL)!)

        } else {
            downloadImage(from: URL(string: "https://schoolshop-lab.jp/wp-content/uploads/2018/11/240ec862387d03003cb4c41cd93cb0be.png")!)
        }
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
     * validationチェック後
     * APIへのリクエスト・画面遷移
     * validationに引っ掛かった場合アラート表示
     */
    @objc func requestRegistration(_ sender: UIButton) {
        let valid = postUser.isValidateToPost()
        switch !valid.result {
        case true:
            finButton.animate()
            apiClient.requestRegistration(postUser: postUser, userDefaults: userDefaults, uid: currentuser!.uid, view: view, indicator: indicator, performSegue: performSegue, errorAlert: errorAlert)
        case false:
            present(AlertCustom().getAlertContrtoller(title: "入力項目", message: valid.msg!), animated: true, completion: nil)
        }
    }
    func errorAlert() {
        present(AlertCustom().getAlertContrtoller(title: "エラー", message: ""), animated: true, completion: nil)
    }
    
    /*
     * フォームのセット
     */
    func setEureka() {
        var rules = RuleSet<String>()
        rules.add(rule: RuleRequired())
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
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.value = selectedImage
                row.clearAction = .no
                row.onChange { [unowned self] row in
                    self.selectedImage = row.value!
                    self.changePV(image: self.selectedImage)
                    // WARN: 拡張子毎に処理分けしてないけど動く。。
                    self.postUser.image = row.value!.toPNGData()
                }
                self.postUser.image = row.value!.toPNGData()
            }
            <<< TextRow("nickName"){ row in
                row.placeholder = "Ex.) 太郎"
                row.add(ruleSet: rules)
                row.add(rule: RuleMaxLength(maxLength: 10))
                row.validationOptions = .validatesOnChange
                row.title = "ニックネーム"
                row.value = currentuser?.displayName
                row.onChange{ row in
                    self.postUser.nickName = row.value
                }
                self.postUser.nickName = row.value
            }
            .cellUpdate{ cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< DateRow("birth"){ row in
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.maximumDate = Date()
                row.title = "生年月日"
                row.onChange{ row in
                    self.postUser.setBirth(birth: row.value!)
                }
            }
            .cellUpdate{ cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
            <<< SegmentedRow<String>("sex"){ row in
                row.options = sexes
                row.title = "性別"
                row.value = "男性"
                row.onChange{ row in
                    self.postUser.setSex(sex: row.value!)
                }
                self.postUser.setSex(sex: row.value!)
            }
            <<< TextRow("hobby"){ row in
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
                row.title = "趣味"
                row.placeholder = "Ex.) サッカー"
                row.onChange{ row in
                    self.postUser.hobby = row.value
                }
            }
            .cellUpdate{ cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.add(ruleSet: rules)
                row.title = "居住地"
                row.options = prefectures
                row.onChange{ row in 
                    self.postUser.setResidence(residence: row.value!)
                }
            }
            .cellUpdate{ cell, row in
                if !row.isValid {
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.add(ruleSet: rules)
                row.title = "職業"
                row.options = jobs
                row.onChange{ row in
                    self.postUser.setJob(job: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.add(ruleSet: rules)
                row.title = "性格"
                row.options = personalitys
                row.onChange{ row in 
                    self.postUser.setPersonality(personality: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.add(ruleSet: rules)
                row.title = "相手の年齢"
                row.options = ages
                row.onChange{ row in
                    self.postUser.setOpponentAge(opponentAgeRange: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.add(ruleSet: rules)
                row.title = "相手の居住地"
                row.options = prefectures
                row.onChange{ row in
                    self.postUser.setOpponentResidence(residence: row.value!)
                }
            }
        +++ Section() { row in
            row.footer = {
                let footer = HeaderFooterView<UIView>(.callback({
                    let fView = UIView(frame: CGRect(x: 0, y: 0,
                                                      width: self.view.frame.width,
                                                      height: 100))
                    self.finButton = self.materialUIButton.setMaterialButton(superView: self.view, title: "登録", y: 30, startColor: UIColor.blueStartColor, endColor: UIColor.blueEndColor)
                    self.finButton.addTarget(self, action: #selector(self.requestRegistration(_:)), for: UIControl.Event.touchUpInside)
                    fView.addSubview(self.finButton)
                    return fView
                }))
                return footer
            }()
        }
        postUser.nickName = (currentuser?.displayName)!
        postUser.uid = (currentuser?.uid)!
    }
}
