//
//  PagingTransitionSource.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/18.
//

import Foundation

internal enum PagingTransitionSource {
  /// This means the transition motivation is original from on tap the menu.
  case menu
  
  /// This means the transition motivation is from user swipe the page's content scroll view.
  case page
}
