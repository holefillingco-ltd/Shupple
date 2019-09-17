//
//  UIImageExtension.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/02.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//
//  urlから画像を取得するinit()
//
//  画像サイズを変更する為のUIImageの拡張機能
//  縮小の場合　image?.scaleImage(scaleSize: 0.5) <- 0.5倍率で縮小
//  画像サイズ変更の場合 let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
//                   image?.reSizeImage(reSize: reSize)

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
    
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
  
    /// イメージ→PNGデータ->Stringに変換する
    /// TODO: エラーハンドリング
    /// - Returns: 変換後のPNG(binary)
    public func toPNGData() -> String {
        guard let data = self.pngData() else {
            return ""
        }
        
        let encodeString = data.base64EncodedString(options: [])
        return encodeString
    }
    
    /// イメージ→JPEGデータ->Stringに変換する
    /// TODO: エラーハンドリング
    /// - Returns: 変換後のJPEG(binary)
    public func toJPEGData() -> String {
        guard let data = self.jpegData(compressionQuality: 1.0) else {
            return ""
        }
        
        let encodeString = data.base64EncodedString(options: [])
        return encodeString
    }
}
