//
//  DateUtils.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/19.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation

class DateUtils {
    let fmt = DateFormatter()
    
    func string2Date(dateStr: String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ'"
        let date = dateFormater.date(from: dateStr)
        return date ?? Date()
    }
}
