//
//  ImageForURL.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/03.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
