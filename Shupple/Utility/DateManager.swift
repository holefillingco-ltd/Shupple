//
//  DateManager.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/18.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
// Timerでカウントダウンを制御するクラス

import Foundation
import UIKit

class DateManager {
    
    private let formatter = DateFormatter()
    private let calendar = Calendar(identifier: .gregorian)
    private var matchingDateStr: String?
    private var matchingDate: Date?
    private var matchingEndDate: Date?
    
    
    init(matchingDate: Date) {
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.dateFormat = "yyyy-MM-dd-HH-mm--ss"
        matchingDateStr = ""
        self.matchingDate = matchingDate
        self.matchingEndDate = Calendar.current.date(byAdding: .day, value: 2, to: self.matchingDate!)
    }
    
    func getNowDate() -> String {
        matchingDateStr = formatter.string(from: matchingDate!)
        guard let dateStr = matchingDateStr else {return ""}
        return dateStr
    }
    
    func getMatchingEndTimeInterval() -> String {
        let span = matchingEndDate?.timeIntervalSinceNow
        if Int(span!) < 0 {
            return "End"
        }
        let fmt = DateComponentsFormatter()
        fmt.unitsStyle = .positional
        fmt.allowedUnits = [.minute,.hour,.second]
        let data = fmt.string(from: span!)
        return data!
    }
}
