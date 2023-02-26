//
//  PagingInvalidateKind.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/26.
//

import UIKit

public enum PagingInvalidateKind {
  case nothing
  case everything
  case size
  
  public init(from context: UICollectionViewLayoutInvalidationContext) {
    if context.invalidateEverything {
      self = .everything
    } else if context.invalidateDataSourceCounts {
      self = .everything
    } else if let context = context as? PagingInvalidationContext, context.invalidateSizes {
      self = .size
    } else {
      self = .nothing
    }
  }
}
