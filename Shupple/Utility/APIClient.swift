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
import SwiftyJSON

class APIClient {
    private let registrationURL = URL(string: "http://localhost:8080/users")
    private let getOpponentURL = URL(string: "http://localhost:8080/users")
    private let updateUserURL = URL(string: "http://localhost:8080/users")
    private let getUserURL = URL(string: "http://localhost:8080/users/select")
    private let isMatchedURL = URL(string: "http://localhost:8080/users/isMatched")
    
    /**
     * POST /users
     * RegistrationVC
     */
    func requestRegistration(postUser: PostUser, userDefaults: UserDefaults, uid: String, view: UIView, indicator: Indicator) {
        
        indicator.start(view: view)
        
        let data = try! JSONEncoder().encode(postUser)
        var request = URLRequest(url: registrationURL!)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(_):
                userDefaults.set(uid, forKey: "UID")
            case .failure(let error):
                print(error)
            }
            indicator.stop(view: view)
        }
    }
    /**
     * GET /users
     * TopVC
     * TODO: decodeエラーハンドリング
     * https://medium.com/@phillfarrugia/encoding-and-decoding-json-with-swift-4-3832bf21c9a8
     */
    func requestGetOpponent(userDefaults: UserDefaults, opponentUid: String, view: UIView, indicator: Indicator, function: @escaping (User) -> Void) {

        indicator.start(view: view)

        var request = URLRequest(url: getOpponentURL!)

        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(opponentUid, forHTTPHeaderField: "Uid")

        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                let opponent = self.decodeUser(json: JSON(value))
                userDefaults.set(opponent.uid, forKey: "OpponentUID")
                function(opponent)
            case .failure(let error):
                print(error)
            }
            indicator.stop(view: view)
        }
    }
    /**
     * PUT /users
     * UpdateUserVC
     */
    func requestUpdateUser(postUser: PostUser, uid: String, view: UIView, indicator: Indicator) {
        
        indicator.start(view: view)
        
        let data = try! JSONEncoder().encode(postUser)
        var request = URLRequest(url: registrationURL!)
        
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(uid, forHTTPHeaderField: "Uid")
        request.httpBody = data
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
            indicator.stop(view: view)
        }
    }
    /**
     * GET /users/select
     * etc..
     */
    func requestGetUser(uid: String, view: UIView, indicator: Indicator, function: @escaping (User) -> Void) {
        
        indicator.start(view: view)
        
        var request = URLRequest(url: getUserURL!)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(uid, forHTTPHeaderField: "Uid")
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                let user = self.decodeUser(json: JSON(value))
                function(user)
            case .failure(let error):
                print(error)
            }
            indicator.stop(view: view)
        }
    }
    /**
     * GET /users/isMatched
     * TopVC
     */
    func requestIsMatched(userDefaults: UserDefaults,uid: String, view: UIView, indicator: Indicator, function: @escaping (User) -> Void) {
        
        indicator.start(view: view)
        
        var request = URLRequest(url: isMatchedURL!)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(uid, forHTTPHeaderField: "Uid")
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                    if JSON(value)["is_matched"].bool! == true {
                        let user = self.decodeIsMatched(json: JSON(value))
                        userDefaults.set(user.uid, forKey: "OpponentUID")
                        function(user)
                }
            case .failure(let error):
                print(error)
            }
            indicator.stop(view: view)
        }
    }
    
    /**
     * JsonからUserへデコード
     * TODO: Codableで出来る様に
     */
    func decodeUser(json: JSON) -> User {
        let user = User()
        let userInformation = UserInformation()
        user.uid = json["uid"].string!
        user.nickName = json["nickName"].string!
        user.setSex(sex: json["sex"].int!)
        user.birthDay = json["birthDay"].string!
        user.age = json["age"].int!
        user.imageURL = json["imageUrl"].string!
        userInformation.hobby = json["user_information"]["hobby"].string!
        userInformation.setResidence(residence: json["user_information"]["residence"].int!)
        userInformation.setJob(job: json["user_information"]["job"].int!)
        userInformation.setPersonality(personality: json["user_information"]["personality"].int!)
        userInformation.setOpponentResidence(residence: json["user_information"]["opponentResidence"].int!)
        user.userInformation = userInformation
        return user
    }
    
    func decodeIsMatched(json: JSON) -> User {
        let user = User()
        let userInformation = UserInformation()
        user.uid = json["user"]["uid"].string!
        user.nickName = json["user"]["nickName"].string!
        user.setSex(sex: json["user"]["sex"].int!)
        user.birthDay = json["user"]["birthDay"].string!
        user.age = json["user"]["age"].int!
        user.imageURL = json["user"]["imageUrl"].string!
        userInformation.hobby = json["user"]["user_information"]["hobby"].string!
        userInformation.setResidence(residence: json["user"]["user_information"]["residence"].int!)
        userInformation.setJob(job: json["user"]["user_information"]["job"].int!)
        userInformation.setPersonality(personality: json["user"]["user_information"]["personality"].int!)
        userInformation.setOpponentResidence(residence: json["user"]["user_information"]["opponentResidence"].int!)
        user.userInformation = userInformation
        return user
    }
    
}
