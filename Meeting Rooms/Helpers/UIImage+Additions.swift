//
//  UIImage+Additions.swift
//  Meeting Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(patternColor: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        var alpha: CGFloat = 0
        patternColor.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        
        UIGraphicsBeginImageContextWithOptions(size, (alpha == 1.0), 1)
        patternColor.set()
        
        UIRectFill(CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(cgImage: image.cgImage!, scale: image.scale, orientation: .up)
    }
}
