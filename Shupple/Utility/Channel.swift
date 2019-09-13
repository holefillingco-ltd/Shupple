//
//  ChannelId.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/13.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

class Channel {
    let id: String?
    
    init(myId: String, opponentId: String) {
        var ids = [myId, opponentId]
        ids.sort()
        self.id = ids.joined(separator: "-")
    }
}
