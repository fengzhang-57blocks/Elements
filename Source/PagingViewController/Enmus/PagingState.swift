//
//  PagingState.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/7.
//

import Foundation

public enum PagingState: Equatable {
	case selected(item: PagingMenuItem)
	case scrolling(
		fromItem: PagingMenuItem,
		toItem: PagingMenuItem?,
		initialContentOffset: CGPoint,
		distance: CGFloat,
    progress: CGFloat
	)
	case empty
}

public extension PagingState {
	var currentPagingMenuItem: PagingMenuItem? {
		switch self {
		case let .selected(item):
			return item
		case let .scrolling(fromItem, _, _, _, _):
			return fromItem
    case .empty:
      return nil
		}
	}
	
	var destinationPagingMenuItem: PagingMenuItem? {
		switch self {
		case let .scrolling(_, toItem, _, _, _):
			return toItem
		case .empty, .selected:
			return nil
		}
	}
  
  var distance: CGFloat {
    switch self {
    case let .scrolling(_, _, _, distance, _):
      return distance
    case .empty, .selected:
      return 0
    }
  }
	
	var progress: CGFloat {
		switch self {
		case let .scrolling(_, _, _, _, progress):
			return progress
		case .empty, .selected:
			return 0
		}
	}
}

public extension PagingState {
	static func == (lhs: PagingState, rhs: PagingState) -> Bool {
		switch (lhs, rhs) {
		case
			(let .scrolling(lhsCurrent, lhsUpcoming, lhsOffset, lhsDistance, lhsProgress),
			 let .scrolling(rhsCurrent, rhsUpcoming, rhsOffset, rhsDistance, rhsProgress)):
			if lhsCurrent.isEqual(to: rhsCurrent),
				 lhsProgress == rhsProgress,
				 lhsOffset == rhsOffset,
				 lhsDistance == rhsDistance {
				if let lhsUpcoming = lhsUpcoming, let rhsUpcoming = rhsUpcoming, lhsUpcoming.isEqual(to: rhsUpcoming) {
					return true
				} else if lhsUpcoming == nil, rhsUpcoming == nil {
					return true
				}
			}
			return false
		case let (.selected(lhsItem), .selected(rhsItem)) where lhsItem.isEqual(to: rhsItem):
			return true
		case (.empty, .empty):
			return true
		default:
			return false
		}
	}
}
