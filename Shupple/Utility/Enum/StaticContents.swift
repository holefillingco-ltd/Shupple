//
//  StaticContents.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/14.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

enum StaticContents: Int {
    case updateUser = 0
    case contactEmail
    case contactChat
    case unsubscribe
    
    var segueIdentifirer: String {
        switch self {
        case .updateUser:
            return "toUpdateView"
        case .contactEmail:
            return "toContactEmail"
        case .contactChat:
            return "toAuthorChat"
        case .unsubscribe:
            return "toUnSubscribe"
        }
    }
}
