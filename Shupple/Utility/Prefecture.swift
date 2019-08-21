//
//  Prefecture.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/22.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
// PrefectureをIntからString, StringからIntへ変換
// Prefecture(code: 1)!.name <- 北海道
// Prefecture(name: "北海道")!.code <- 1

import Foundation

/// 都道府県コード
internal enum PrefectureCode: Int {
    case hokkaido = 1
    case aomori
    case iwate
    case miyagi
    case akita
    case yamagata
    case fukushima
    case ibaraki
    case tochigi
    case gunma
    case saitama
    case chiba
    case tokyo
    case kanagawa
    case niigata
    case toyama
    case ishikawa
    case fukui
    case yamanashi
    case nagano
    case gifu
    case shizuoka
    case aichi
    case mie
    case shiga
    case kyoto
    case osaka
    case hyogo
    case nara
    case wakayama
    case tottori
    case shimane
    case okayama
    case hiroshima
    case yamaguchi
    case tokushima
    case kagawa
    case ehime
    case kochi
    case fukuoka
    case saga
    case nagasaki
    case kumamoto
    case oita
    case miyazaki
    case kagoshima
    case okinawa
}

/// 都道府県名
internal enum PrefectureName: String {
    case 北海道
    case 青森県
    case 岩手県
    case 宮城県
    case 秋田県
    case 山形県
    case 福島県
    case 茨城県
    case 栃木県
    case 群馬県
    case 埼玉県
    case 千葉県
    case 東京都
    case 神奈川県
    case 新潟県
    case 富山県
    case 石川県
    case 福井県
    case 山梨県
    case 長野県
    case 岐阜県
    case 静岡県
    case 愛知県
    case 三重県
    case 滋賀県
    case 京都府
    case 大阪府
    case 兵庫県
    case 奈良県
    case 和歌山県
    case 鳥取県
    case 島根県
    case 岡山県
    case 広島県
    case 山口県
    case 徳島県
    case 香川県
    case 愛媛県
    case 高知県
    case 福岡県
    case 佐賀県
    case 長崎県
    case 熊本県
    case 大分県
    case 宮崎県
    case 鹿児島県
    case 沖縄県
}

/// 都道府県
public enum Prefecture {
    case hokkaido
    case aomori
    case iwate
    case miyagi
    case akita
    case yamagata
    case fukushima
    case ibaraki
    case tochigi
    case gunma
    case saitama
    case chiba
    case tokyo
    case kanagawa
    case niigata
    case toyama
    case ishikawa
    case fukui
    case yamanashi
    case nagano
    case gifu
    case shizuoka
    case aichi
    case mie
    case shiga
    case kyoto
    case osaka
    case hyogo
    case nara
    case wakayama
    case tottori
    case shimane
    case okayama
    case hiroshima
    case yamaguchi
    case tokushima
    case kagawa
    case ehime
    case kochi
    case fukuoka
    case saga
    case nagasaki
    case kumamoto
    case oita
    case miyazaki
    case kagoshima
    case okinawa
}

// MARK: -
extension Prefecture {
    
    /// 都道府県コードで初期化
    public init?(code: Int) {
        self.init(PrefectureCode(rawValue: code))
    }
    
    /// 都道府県名で初期化
    public init?(name: String) {
        self.init(PrefectureName(rawValue: name))
    }
    
    /// 都道府県コード
    public var code: Int {
        return converted(PrefectureCode.self).rawValue
    }
    
    /// 都道府県名
    public var name: String {
        return converted(PrefectureName.self).rawValue
    }
    
    private init?<T>(_ t: T?) {
        guard let t = t else { return nil }
        self = unsafeBitCast(t, to: Prefecture.self)
    }
    
    private func converted<T>(_ t: T.Type) -> T {
        return unsafeBitCast(self, to: t)
    }
}

