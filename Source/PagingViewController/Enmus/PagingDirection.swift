//
//  PagingDirection.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/12.
//

import Foundation

public enum PagingDirection {
  case forward
  case reverse
  case none
  
  init(progress: CGFloat) {
    if progress > 0 {
      self = .forward
    } else if progress < 0 {
      self = .reverse
    } else {
      self = .none
    }
  }
}
