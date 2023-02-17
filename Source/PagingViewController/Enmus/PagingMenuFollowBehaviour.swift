//
//  PagingMenuFollowBehaviour.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/13.
//

import Foundation

// TODO: Use `PagingMenuFollowBehaviour` to represent paging menu scrolling behaviour

/// Use `PagingMenuFollowBehaviour` to represent paging menu scrolling behaviour
/// `scrollAlongside` means paging menu will adjust it's contentOffset alongwith page scrolling
/// `animateAfter` means paging menu will adjust it's contentOffset after page scroll done.

public enum PagingMenuFollowBehaviour {
	case scrollAlongside
	case animateAfter
}
