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
    
    /**
     * POST /users
     * RegistrationVC
     */
    func requestRegistration(view: UIView, postUser: PostUser, userDefaults: UserDefaults, uid: String) {
        let indicator = Indicator(view: view)
        indicator.start()
        
        let data = try! JSONEncoder().encode(postUser)
        var request = URLRequest(url: registrationURL!)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
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
    func requestGetOpponen() {
    }
}
