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
    var nickName: String? = ""
    var opponentAgeLow: Int = 1
    var opponentAgeUpper: Int = 1
    var hobby: String? = ""
    
    /*
     * set関数を使用してアクセス
     */
    private var sex: Int = 1
    private var birthDay: String = ""
    private var residence: Int = 1
    private var job: Int = 1
    private var personality: Int = 1

    func setSex(sex: String) {
        self.sex = Sex.init(name: sex)!.code
    }
    
    func setBirth(birth: Date) {
        let fmt = ISO8601DateFormatter()
        self.birthDay = fmt.string(from: birth)
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
    
    func setOpponentAge(opponentAgeRange: String) {
        switch opponentAgeRange {
        case "18~20":
            self.opponentAgeLow = 18
            self.opponentAgeUpper = 20
        case "20~25":
            self.opponentAgeLow = 20
            self.opponentAgeUpper = 25
        case "25~30":
            self.opponentAgeLow = 25
            self.opponentAgeUpper = 30
        case "30~35":
            self.opponentAgeLow = 30
            self.opponentAgeUpper = 35
        default:
            self.opponentAgeLow = 1
            self.opponentAgeUpper = 100
        }
    }
}
