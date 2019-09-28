//
//  AlertCustom.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/27.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import Foundation
import UIKit

struct AlertCustom {
    func getAlertContrtoller(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let btn = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(btn)
        return alert
    }
}
