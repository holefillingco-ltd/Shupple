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
    private let getOpponentURL = URL(string: "http://localhost:8080/users/shupple")
    private let cancelOpponentURL = URL(string: "http://localhost:8080/users/shupple")
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
            debugPrint(response)
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
     * GET /users/shupple
     * TopVC
     * TODO: decodeエラーハンドリング
     * https://medium.com/@phillfarrugia/encoding-and-decoding-json-with-swift-4-3832bf21c9a8
     */
    func requestGetOpponent(userDefaults: UserDefaults, opponentUid: String, view: UIView, indicator: Indicator, userConvertToUILabelFunc: @escaping (User) -> Void, dateManagerStartFunc: @escaping (Date) -> Void) {

        indicator.start(view: view)

        var request = URLRequest(url: getOpponentURL!)

        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(opponentUid, forHTTPHeaderField: "Uid")

        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                let opponent = self.decodeUser(json: JSON(value))
                if opponent.isMatched {
                    dateManagerStartFunc(opponent.matchingDate!)
                }
                userDefaults.set(opponent.user.uid, forKey: "OpponentUID")
                userConvertToUILabelFunc(opponent.user)
            case .failure(let error):
                print(error)
            }
            indicator.stop(view: view)
        }
    }
    /**
     * PUT /users/shupple
     * TopVC
     */
    func requestCancelOpponent(userDefaults: UserDefaults, uid: String, view: UIView, indicator: Indicator) {
        
        indicator.start(view: view)
        
        var request = URLRequest(url: cancelOpponentURL!)
        
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue(uid, forHTTPHeaderField: "Uid")
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                userDefaults.set("default", forKey: "MatchingTime")
                userDefaults.set("default", forKey: "OpponentUID")
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
                function(user.user)
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
    func requestIsMatched(userDefaults: UserDefaults,uid: String, view: UIView, indicator: Indicator, userConvertToUILabelFunc: @escaping (User) -> Void, dateManagerStartFunc: @escaping (Date) -> Void) {
        
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
                    userDefaults.set(user.user.uid, forKey: "OpponentUID")
                    userDefaults.set(user.matchingDate, forKey: "MatchingTime")
                    userConvertToUILabelFunc(user.user)
                    let matchingDate = user.matchingDate
                    dateManagerStartFunc(matchingDate)
                }
            case .failure(let error):
                print(error)
            }
            indicator.stop(view: view)
        }
    }
    /**
     * JsonからUserへデコード
     * TODO: CodableとcomputedPropertieを使用する様変更
     */
    private func decodeUser(json: JSON) -> (user: User, matchingDate: Date?, isMatched: Bool) {
        let user = User()
        let userInformation = UserInformation()
        user.uid = json["uid"].string!
        user.nickName = json["nickName"].string!
        user.setSex(sex: json["sex"].int!)
        user.birthDay = json["birthDay"].string!
        user.age = json["age"].int!
        user.imageURL = json["imageUrl"].string!
        userInformation.hobby = json["userInformation"]["hobby"].string!
        userInformation.setResidence(residence: json["userInformation"]["residence"].int!)
        userInformation.setJob(job: json["userInformation"]["job"].int!)
        userInformation.setPersonality(personality: json["userInformation"]["personality"].int!)
        userInformation.setOpponentResidence(residence: json["userInformation"]["opponentResidence"].int!)
        user.userInformation = userInformation
        if json["userCombination"]["ID"].int! == 0 {
            return (user, nil, false)
        }
        let matchingDateStr: String = json["userCombination"]["CreatedAt"].string!
        let dateUtils = DateUtils()
        let matchingDate = dateUtils.string2Date(dateStr: matchingDateStr)
        return (user, matchingDate, true)
    }
    private func decodeIsMatched(json: JSON) -> (user: User, matchingDate: Date) {
        let user = User()
        let userInformation = UserInformation()
        user.uid = json["user"]["uid"].string!
        user.nickName = json["user"]["nickName"].string!
        user.setSex(sex: json["user"]["sex"].int!)
        user.birthDay = json["user"]["birthDay"].string!
        user.age = json["user"]["age"].int!
        user.imageURL = json["user"]["imageUrl"].string!
        userInformation.hobby = json["user"]["userInformation"]["hobby"].string!
        userInformation.setResidence(residence: json["user"]["userInformation"]["residence"].int!)
        userInformation.setJob(job: json["user"]["userInformation"]["job"].int!)
        userInformation.setPersonality(personality: json["user"]["userInformation"]["personality"].int!)
        userInformation.setOpponentResidence(residence: json["user"]["userInformation"]["opponentResidence"].int!)
        user.userInformation = userInformation
        let matchingDateStr: String = json["user"]["userCombination"]["CreatedAt"].string!
        let dateUtils = DateUtils()
        let matchingDate = dateUtils.string2Date(dateStr: matchingDateStr)
        return (user, matchingDate)
    }
}
