//
//  SegmentControlDataSource.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/5.
//

import UIKit

public protocol SegmentControlDataSource: AnyObject {
  func numberOfItems(in segmentControl: SegmentControl) -> Int
  func segmentControl(_ segmentControl: SegmentControl, cellForItemAt index: Int) -> UICollectionViewCell
  func segmentControl(_ segmentControl: SegmentControl, segmentAt index: Int) -> Segment
}
