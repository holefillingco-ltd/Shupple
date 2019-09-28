//
//  UserInformation.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/03.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

class UserInformation: Codable {
    var hobby: String?
    var residence: String?
    var job: String?
    var personality: String?
    var opponentResidence: String?
    var opponentAgeKey: Int?
    
    func setResidence(residence: Int) {
        self.residence = Prefecture.init(code: residence)!.name
    }
    
    func setJob(job: Int) {
        self.job = Job.init(code: job)!.name
    }
    
    func setPersonality(personality: Int) {
        self.personality = Personality.init(code: personality)!.name
    }
    
    func setOpponentResidence(residence: Int) {
        self.opponentResidence = Prefecture.init(code: residence)!.name
    }
    
    func getOpponentAgeRange() -> String {
        switch self.opponentAgeKey {
        case 18:
            return "18~20"
        case 20:
            return "20~25"
        case 25:
            return "25~30"
        case 30:
            return "30~35"
        default:
            return "指定無し"
        }
    }
}
