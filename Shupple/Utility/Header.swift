//
//  Header.swift
//  AppAuth
//
//  Created by 磯崎 裕太 on 2019/10/04.
//

import UIKit
import Foundation

class Header {
    
    func setHeader(header: UINavigationBar, view: UIView, color: UIColor)  {
        let safeArea = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 44))
        safeArea.backgroundColor = color
        header.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: 44)
        header.barTintColor = color
        header.isTranslucent = false
        view.addSubview(header)
        view.addSubview(safeArea)
    }
}
