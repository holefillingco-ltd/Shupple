//
//  Sex.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/22.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
// SexをIntからString, StringからIntへ変換
// 0 -> 男性
// 1 -> 女性
// Sex(code: 0)!.name <- 男性
// Sex(name: "女性")!.code <- 1

import Foundation

internal enum SexCode: Int {
    case man = 1
    case female
}

internal enum SexStr: String, CaseIterable {
    case 男性
    case 女性
}

public enum Sex {
    case man
    case female
}

extension Sex {
    
    static var allSex: [String] {
        var allSex: Array<String> = Array()
        for job in SexStr.allCases {
            allSex.append(job.rawValue)
        }
        return allSex
    }
    
    public init?(code: Int) {
        self.init(SexCode(rawValue: code))
    }
    
    public init?(name: String) {
        self.init(SexStr(rawValue: name))
    }
    
    public var code: Int {
        return converted(SexCode.self).rawValue
    }
    
    public var name: String {
        return converted(SexStr.self).rawValue
    }
    
    private init?<T>(_ t: T?) {
        guard let t = t else { return nil }
        self = unsafeBitCast(t, to: Sex.self)
    }
    
    private func converted<T>(_ t: T.Type) -> T {
        return unsafeBitCast(self, to: t)
    }
}
