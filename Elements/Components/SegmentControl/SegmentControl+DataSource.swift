//
//  SegmentControl+DataSource.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/5.
//

import UIKit

protocol SegmentControlDataSource {
  func numberOfItemsInSegmentControl(_ segmentControl: SegmentControl) -> Int
  func segmentControl(_ segmentControl: SegmentControl, cellForItemAt index: Int) -> UICollectionViewCell
}
