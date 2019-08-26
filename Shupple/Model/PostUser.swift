//
//  PostUser.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/27.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

class PostUser: Codable {
    var uid: String = ""
    var nickName: String = ""
    private var sex: Int = 1
    private var birthDay: String = ""
    var age: Int = 1
    var opponentAge: String = ""
    var hobby: String = ""
    private var residence: Int = 1
    private var job: Int = 1
    private var personality: Int = 1
    
    func setSex(sex: String) {
        self.sex = Sex.init(name: sex)!.code
    }
    
    func setResidence(residence: String) {
        self.residence = Prefecture.init(name: residence)!.code
    }
    
    func setJob(job: String) {
        self.job = Job.init(name: job)!.code
    }
    
    func setPersonality(personality: String) {
        self.personality = Personality.init(name: personality)!.code
    }
}
