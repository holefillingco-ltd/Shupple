//
//  Personality.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/22.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
// PersonalityをIntからString, StringからIntへ変換
// Personality(code: 1)!.name <- 努力家
// Personality(name: "努力家")!.code <- 1

import Foundation

internal enum PersonalityCode: Int {
    case effort = 1
    case compassion
    case responsible
    case bright
    case shyness
    case stimulation
    case peace
    case adventure
    case fun
    case life
    case belief
    case happiness
    case creative
    case entrepreneur
    case leader
    case other
}

internal enum PersonalityStr: String {
    case 努力家
    case 思いやり家
    case 責任感が強い
    case 明るい
    case 人見知り
    case 刺激家
    case 平和的
    case 冒険家
    case 楽しみたい
    case 人生で追い求めている物がある
    case 信念がある
    case 人が幸せだと嬉しい
    case 独創的
    case 起業家気質
    case リーダー気質
    case どれも当てはまらない
}

public enum Personality {
    case effort
    case compassion
    case responsible
    case bright
    case stimulation
    case peace
    case adventure
    case fun
    case life
    case belief
    case happiness
    case creative
    case entrepreneur
    case leader
    case other
}

// MARK: -
extension Personality {
    
    public init?(code: Int) {
        self.init(PersonalityCode(rawValue: code))
    }
    
    public init?(name: String) {
        self.init(PersonalityStr(rawValue: name))
    }
    
    public var code: Int {
        return converted(PersonalityCode.self).rawValue
    }
    
    public var name: String {
        return converted(PersonalityStr.self).rawValue
    }
    
    private init?<T>(_ t: T?) {
        guard let t = t else { return nil }
        self = unsafeBitCast(t, to: Personality.self)
    }
    
    private func converted<T>(_ t: T.Type) -> T {
        return unsafeBitCast(self, to: t)
    }
}
