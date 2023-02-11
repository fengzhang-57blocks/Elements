//
//  PagingMenuState.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/7.
//

import Foundation

public enum PagingMenuState: Equatable {
	case empty
	case selected(item: PagingMenuItem)
	case scrolling(
		currentPagingItem: PagingMenuItem,
		upcomingPagingItem: PagingMenuItem?,
		progress: CGFloat,
		initialContentOffset: CGPoint,
		distance: CGFloat
	)
}

public extension PagingMenuState {
	var currentPagingMenuItem: PagingMenuItem? {
		switch self {
		case .empty:
			return nil
		case .selected(let item):
			return item
		case .scrolling(let currentPagingItem, _, _, _, _):
			return currentPagingItem
		}
	}
	
	var upcomingPagingMenuItem: PagingMenuItem? {
		switch self {
		case .scrolling(_, let upcomingPagingItem, _, _, _):
			return upcomingPagingItem
		case .empty, .selected:
			return nil
		}
	}
	
	var progress: CGFloat {
		switch self {
		case .scrolling(_, _, let progress, _, _):
			return progress
		case .empty, .selected:
			return 0
		}
	}
	
	var distance: CGFloat {
		switch self {
		case .scrolling(_, _, _, _, let distance):
			return distance
		case .empty, .selected:
			return 0
		}
	}
}

public extension PagingMenuState {
	static func == (lhs: PagingMenuState, rhs: PagingMenuState) -> Bool {
		switch (lhs, rhs) {
		case
			(let .scrolling(lhsCurrent, lhsUpcoming, lhsProgress, lhsOffset, lhsDistance),
			 let .scrolling(rhsCurrent, rhsUpcoming, rhsProgress, rhsOffset, rhsDistance)):
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
