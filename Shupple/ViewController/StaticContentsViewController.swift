//
//  StaticContentsViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/11.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit

class StaticContentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let staticContents = ["プロフィール編集", "お知らせ", "お問い合わせ"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     * セルの数を設定
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticContents.count
    }
    
    /**
     * セルに表示する値を設定
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "staticContents", for: indexPath)
        cell.textLabel!.text = staticContents[indexPath.row]
        return cell
    }
}
