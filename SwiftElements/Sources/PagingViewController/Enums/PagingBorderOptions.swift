//
//  PagingBorderOptions.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/26.
//

import UIKit

public enum PagingBorderOptions {
  case hidden
  case visible(
    height: CGFloat,
    insets: UIEdgeInsets,
    zIndex: Int
  )
}
