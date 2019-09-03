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
    
    func setResidence(residence: Int) {
        self.residence = Prefecture.init(code: residence)!.name
    }
    
    func setJob(job: Int) {
        self.job = Job.init(code: job)!.name
    }
    
    func setPersonality(personality: Int) {
        self.personality = Personality.init(code: personality)!.name
    }
    
}
