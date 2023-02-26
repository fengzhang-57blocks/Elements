//
//  PagingItemLayout.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/9.
//

import UIKit

public struct PagingItemLayout {
  let frame: CGRect
  
  init(frame: CGRect) {
    self.frame = frame
  }
}

extension PagingItemLayout {
  var x: CGFloat {
    return frame.origin.x
  }
  
  var width: CGFloat {
    return frame.size.width
  }
}
