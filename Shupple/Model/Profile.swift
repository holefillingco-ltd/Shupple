//
//  Profile.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/21.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

public struct Profile: Codable {
    public var id: Int
    public var uid: String
    public var nickName: String
    public var sex: String
    public var birthDay: String
    public var age: Int
    public var opponentAge: Int
    public var imageURL: String?
    public var hobby: String
    public var residence: Int
    public var job: Int
    public var personality: Int
    
    init(
        id: Int, uid: String, nickName: String, sex: Int,
        birthDay: String, age: Int, opponentAge: Int,
        imageURL: String?, hobby: String, residence: Int,
        job: Int, personality: Int
    ) {
        self.id = id
        self.uid = uid
        self.nickName = nickName
        self.sex = self.getSex(sex: sex)
        self.birthDay = birthDay
        self.age = age
        self.opponentAge = opponentAge
        self.imageURL = imageURL
        self.hobby = hobby
        self.residence = residence
        self.job = job
        self.personality = personality
    }
}
