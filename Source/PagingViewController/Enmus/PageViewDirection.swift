//
//  PageViewDirection.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/12.
//

import Foundation

public enum PageViewDirection {
  case forward
  case backward
  case none
  
  init(progress: CGFloat) {
    if progress > 0 {
      self = .forward
    } else if progress < 0 {
      self = .backward
    } else {
      self = .none
    }
  }
}
