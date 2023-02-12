//
//  PageViewPosition.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/12.
//

import Foundation

public enum PageViewPosition {
  case empty
  case single
  case first
  case centered
  case last
  
  var proposedPageCount: Int {
    switch self {
    case .single: return 1
    case .first, .last: return 2
    case .centered: return 3
    case .empty:
      return 0
    }
  }
}
