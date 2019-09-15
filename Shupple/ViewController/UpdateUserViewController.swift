//
//  UpdateUserViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/14.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import FirebaseAuth

class UpdateUserViewController: FormViewController {
    
    private let currentuser = Auth.auth().currentUser
    private let prefectures = Prefecture.allPrefectures
    private let jobs = Job.allJob
    private let personalitys = Personality.allPersonality
    private let ages = ["18~20", "20~25", "25~30", "30~35", "指定無し"]
    private let sexes = Sex.allSex
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    private let currentUserUid = UserDefaults.standard.object(forKey: "UID") as! String
    private let indicator = Indicator()
    private let apiClient = APIClient()
    private let materialUIButton = MaterialUIButton()
    private var finBtn = SpringButton()
    
    private var selectedImage = UIImage()
    private var pView = UIView()
    private var postUser = PostUser()
    private var currentUser = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
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
    /**
     * 各フォームのvalueに表示するためcurrentUserを取得する
     */
    func getUser() {
        apiClient.requestGetUser(uid: currentUserUid, view: view, indicator: indicator, function: convertUser)
    }
    /**
     * TODO: やばすぎ。。
     */
    private func convertUser(user: User) {
        currentUser = user
        setEureka()
    }
    /**
     * finBtnを押した時に呼ばれる
     */
    @objc func requestUpdateUser(_ sender: UIButton) {
        finBtn.animate()
        apiClient.requestUpdateUser(postUser: postUser, uid: currentUserUid, view: view, indicator: indicator)
    }
    /*
     * フォームのセット
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
                row.value = currentUser.nickName
                row.onChange{ row in
                    self.postUser.nickName = row.value!
                }
            }
            <<< TextRow("hobby"){ row in
                row.title = "趣味"
                row.value = currentUser.userInformation?.hobby
                row.placeholder = "Ex.) サッカー"
                row.onChange{ row in
                    self.postUser.hobby = row.value!
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "居住地"
                row.options = prefectures
                row.value = currentUser.userInformation?.residence
                row.onChange{ row in
                    self.postUser.setResidence(residence: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "職業"
                row.options = jobs
                row.value = currentUser.userInformation?.job
                row.onChange{ row in
                    self.postUser.setJob(job: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "性格"
                row.options = personalitys
                row.value = currentUser.userInformation?.personality
                row.onChange{ row in
                    self.postUser.setPersonality(personality: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "相手の年齢"
                row.options = ages
                row.onChange{ row in
                    self.postUser.setOpponentAge(opponentAgeRange: row.value!)
                }
            }
            <<< PickerInlineRow<String>() { row in
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
                                                         height: 300))
                        self.finBtn = self.materialUIButton.setMaterialButton(superView: self.view, title: "登録", y: 30, startColor: UIColor.blueStartColor, endColor: UIColor.blueEndColor)
                        self.finBtn.addTarget(self, action: #selector(self.requestUpdateUser(_:)), for: UIControl.Event.touchUpInside)
                        fView.addSubview(self.finBtn)
                        return fView
                    }))
                    return footer
                }()
        }
    }
}
