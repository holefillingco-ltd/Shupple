//
//  ImageScale.swift
//  Shupple
//
//  Created by 磯崎裕太 on 2019/08/02.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//  画像サイズを変更する為のUIImageの拡張機能
//  縮小の場合　image?.scaleImage(scaleSize: 0.5) <- 0.5倍率で縮小
//  画像サイズ変更の場合 let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
//                   image?.reSizeImage(reSize: reSize)

import UIKit

extension UIImage {
    
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
