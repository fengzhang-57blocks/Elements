//
//  UIColorExtensions.swift
//  Examples
//
//  Created by feng.zhang on 2023/3/12.
//

import UIKit

extension UIColor {
  func components() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
    guard let c = cgColor.components else { return (0, 0, 0, 1) }
    if cgColor.numberOfComponents == 1 {
      return (0, 0, 0, 1)
    } else if cgColor.numberOfComponents == 2 {
      return (c[0], c[0], c[0], c[1])
    } else {
      return (c[0], c[1], c[2], c[3])
    }
  }
  
  static func interpolate(
    from fromColor: UIColor,
    to toColor: UIColor,
    percentage: CGFloat
  ) -> UIColor? {
    let f = min(1, max(0, percentage))
    let c1 = fromColor.components()
    let c2 = toColor.components()
    let r = c1.0 + (c2.0 - c1.0) * f
    let g = c1.1 + (c2.1 - c1.1) * f
    let b = c1.2 + (c2.2 - c1.2) * f
    let a = c1.3 + (c2.3 - c1.3) * f
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}
