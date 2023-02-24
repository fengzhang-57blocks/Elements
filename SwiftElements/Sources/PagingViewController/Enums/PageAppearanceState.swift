//
//  PageAppearanceState.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/19.
//

import Foundation

internal enum PageAppearanceState {
  case willAppear(animated: Bool)
  case didAppear
  case willDisappear(animated: Bool)
  case didDisappear
}
