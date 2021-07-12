//
//  UIImage+Extension.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import Foundation
import UIKit

extension UIImage {
    
    func resize(width: Int = 30, height: Int = 30) -> UIImage? {
        let originalSize = CGSize(width: width, height: height)
        let widthRatio = originalSize.width / size.width
        let heightRatio = originalSize.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}

