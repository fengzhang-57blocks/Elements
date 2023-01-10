//
//  UIImage.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/1/9.
//

import UIKit

extension UIImage {
  static func fromBundle(_ bundleName: String, imageName: String) -> UIImage? {
    if let filePath = Bundle.main.path(forResource: bundleName, ofType: "bundle") {
      return UIImage(
        named: imageName,
        in: Bundle(path: filePath),
        compatibleWith: nil
      )
    }
    
    return nil
  }
}
