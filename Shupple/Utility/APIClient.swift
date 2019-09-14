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
    private let getUserURL = URL(string: "http://localhost:8080/users/select")
    
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
                userDefaults.set(uid, forKey: "UID")
                print(error)
            }
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
        let matchingTime = Date()

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
     * GET /users/select
     * TopVC, etc..
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
     * JsonからUserへデコード
     * TODO: Codableで出来る様に
     */
    func decodeUser(json: JSON) -> User {
        let opponent = User()
        let opponentUserInformation = UserInformation()
        print(json)
        opponent.uid = json["uid"].string!
        opponent.nickName = json["nickName"].string!
        opponent.setSex(sex: json["sex"].int!)
        opponent.birthDay = json["birthDay"].string!
        opponent.age = json["age"].int!
        opponent.imageURL = json["imageUrl"].string!
        opponentUserInformation.hobby = json["user_information"]["hobby"].string!
        opponentUserInformation.setResidence(residence: json["user_information"]["residence"].int!)
        opponentUserInformation.setJob(job: json["user_information"]["job"].int!)
        opponentUserInformation.setPersonality(personality: json["user_information"]["personality"].int!)
        opponent.userInformation = opponentUserInformation
        return opponent
    }
}
