//
//  APIClient.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/09/04.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class APIClient {
    let registrationURL = URL(string: "http://localhost:8080/users")
    let getOpponentURL = URL(string: "http://localhost:8080/users")
    
    /**
     * POST /users
     * RegistrationVC
     */
    func requestRegistration(postUser: PostUser, userDefaults: UserDefaults, uid: String, indicator: Indicator) {
        indicator.start()
        
        let data = try! JSONEncoder().encode(postUser)
        var request = URLRequest(url: registrationURL!)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(_):
                userDefaults.set(uid, forKey: "UID")
                indicator.stop()
            case .failure(let error):
                print(error)
            }
        }
    }
    /**
     * GET /users
     * TopVC
     */
    func requestGetOpponen(opponent: User, uid: String, indicator: Indicator) {
        indicator.start()
        var request = URLRequest(url: getOpponentURL!)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(uid, forHTTPHeaderField: "UID")
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                opponent = try! JSONDecoder().decode(User.self, from: value as! Data)
            case .failure(let error):
                print(error)
            }
        }

    }
}
