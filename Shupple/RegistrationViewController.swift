//
//  RegistrationViewController.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/01.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import FirebaseAuth

class RegistrationViewController: FormViewController {
    
    let user = Auth.auth().currentUser
    var selectedImage = UIImage()
    var defaultPI = UIImage()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.defaultPI = UIImage(data: data)!
                self.setEureka()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage(from: (user?.photoURL)!)
    }
    
    func setEureka() {
        form
            +++ Section() {
                $0.header = {
                    let header = HeaderFooterView<UIView>(.callback({
                        let view = UIView(frame: CGRect(x: 0, y: 0,
                                                        width: self.view.frame.width, height: 300))
                        view.addSubview(UIImageView(image: self.defaultPI))
                        return view
                    }))
                    return header
                }()
            }
            +++ Section("Profile")
            <<< ImageRow(){
                $0.title = "プロフィール画像"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.value = defaultPI
                $0.clearAction = .no
                $0.onChange { [unowned self] row in
                    self.selectedImage = row.value!
                }
            <<< TextRow("nickName"){ row in
                row.title = "ニックネーム"
                row.value = user?.displayName
            }
        }
    }
}
