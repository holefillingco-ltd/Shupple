//
//  Job.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/22.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
// JobをIntからString, StringからIntへ変換
// Job(code: 1)!.name <- 会社員
// Job(name: "会社員")!.code <- 1

import Foundation

internal enum JobCode: Int {
   case employee = 1
   case civil
   case manager
   case medical
   case welfare
   case beauty
   case apparel
   case travel
   case eat
   case education
   case publication
   case entertainment
   case sport
   case play
   case design
   case it
   case law
   case finance
   case international
   case architecture
   case officework
   case company
   case transportation
   case funeral
   case student
   case other
}

internal enum JobName: String {
    case 会社員
    case 公務員
    case 経営者・役員
    case 医療
    case 福祉
    case 美容
    case ファッション
    case 旅行
    case 飲食
    case 教育
    case 出版・メディア
    case 芸能・音楽
    case スポーツ
    case マンガ・アニメ・ゲーム
    case デザイン・アート
    case IT関連
    case 法律・政治
    case 金融・保険
    case 国際
    case 建築・インテリア・不動産
    case 事務
    case 企業
    case 運輸・輸送
    case 冠婚葬祭
    case 学生
    case その他
}

public enum Job {
    case employee
    case civil
    case manager
    case medical
    case welfare
    case beauty
    case apparel
    case travel
    case eat
    case education
    case publication
    case entertainment
    case sport
    case play
    case design
    case it
    case law
    case finance
    case international
    case architecture
    case officework
    case company
    case transportation
    case funeral
    case student
    case other
}

extension Job {
    
    public init?(code: Int) {
        self.init(JobCode(rawValue: code))
    }
    
    public init?(name: String) {
        self.init(JobName(rawValue: name))
    }
    
    public var code: Int {
        return converted(JobCode.self).rawValue
    }
    
    public var name: String {
        return converted(JobName.self).rawValue
    }
    
    private init?<T>(_ t: T?) {
        guard let t = t else { return nil }
        self = unsafeBitCast(t, to: Job.self)
    }
    
    private func converted<T>(_ t: T.Type) -> T {
        return unsafeBitCast(self, to: t)
    }
}
