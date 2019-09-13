//
//  Profile.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/21.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

class User: Codable {
    var uid: String?
    var nickName: String?
    var sex: String?
    var birthDay: String?
    var age: Int?
    var imageURL: String = "https://schoolshop-lab.jp/wp-content/uploads/2018/11/240ec862387d03003cb4c41cd93cb0be.png"
    var userInformation: UserInformation?

    func setSex(sex: Int) {
        self.sex = Sex.init(code: sex)!.name
    }
    
    func setImage(image: String?) {
        if image != nil {
            self.imageURL = image!
        }
    }
}
