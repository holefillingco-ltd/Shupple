//
//  Profile.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/21.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

public class Profile: Codable {
    var uid: String
    var nickName: String
    var sex: String
    var birthDay: String
    var age: Int
    var opponentAge: Int
    var imageURL: String?
    var hobby: String
    var residence: String
    var job: String
    var personality: String
    
    init(
        uid: String, nickName: String, sex: Int,
        birthDay: String, age: Int, opponentAge: Int,
        imageURL: String?, hobby: String, residence: Int,
        job: Int, personality: Int
    ) {
        self.uid = uid
        self.nickName = nickName
        self.sex = Sex(code: sex)!.name
        self.birthDay = birthDay
        self.age = age
        self.opponentAge = opponentAge
        self.imageURL = imageURL
        self.hobby = hobby
        self.residence = Prefecture(code: residence)!.name
        self.job = Job(code: job)!.name
        self.personality = Personality(code: personality)!.name
    }
}
