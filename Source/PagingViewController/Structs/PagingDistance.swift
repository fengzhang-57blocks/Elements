//
//  PagingDistance.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/20.
//

import UIKit

struct PagingDistance {
  private let fromItem: PagingItem
  private let toItem: PagingItem
  private let collectionView: UICollectionView
  private let layoutAttributes: [IndexPath: PagingMenuCellLayoutAttributes]
  private let sizeCache: PagingItemSizeCache
  private let visibleItems: PagingItems
  
  private let fromItemLayoutAttributes: PagingMenuCellLayoutAttributes?
  private let toItemLayoutAttributes: PagingMenuCellLayoutAttributes
  
  init?(
    fromItem: PagingItem,
    toItem: PagingItem,
    collectionView: UICollectionView,
    layoutAttributes: [IndexPath : PagingMenuCellLayoutAttributes],
    sizeCache: PagingItemSizeCache,
    visibleItems: PagingItems
  ) {
    guard let toIndexPath = visibleItems.indexPath(for: toItem),
      let toItemLayoutAttributes = layoutAttributes[toIndexPath] else {
      return nil
    }
    
    self.fromItem = fromItem
    self.toItem = toItem
    self.collectionView = collectionView
    self.layoutAttributes = layoutAttributes
    self.sizeCache = sizeCache
    self.visibleItems = visibleItems
    
    self.toItemLayoutAttributes = toItemLayoutAttributes
    if let fromIndexPath = visibleItems.indexPath(for: fromItem),
       let fromItemLayoutAttributes = layoutAttributes[fromIndexPath] {
      self.fromItemLayoutAttributes = fromItemLayoutAttributes
    } else {
      fromItemLayoutAttributes = nil
    }
  }
  
  func toItemCenter() -> CGPoint {
    return toItemLayoutAttributes.center
  }
  
  func calculate() -> CGFloat {
    var distance: CGFloat = 0
    
    distance = toItemCenter().x - collectionView.bounds.midX
    
    if toItemCenter().x
    
    print(distance)
    
    return distance
  }
}
