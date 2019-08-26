//
//  Profile.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/21.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

public class Profile: Codable {
    public var id: Int
    public var uid: String
    public var nickName: String
    public var sex: String
    public var birthDay: String
    public var age: Int
    public var opponentAge: Int
    public var imageURL: String?
    public var hobby: String
    public var residence: String
    public var job: String
    public var personality: String
    
    init(
        id: Int, uid: String, nickName: String, sex: Int,
        birthDay: String, age: Int, opponentAge: Int,
        imageURL: String?, hobby: String, residence: Int,
        job: Int, personality: Int
    ) {
        self.id = id
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
