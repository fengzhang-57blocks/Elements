//
//  Distance.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/17.
//

import Foundation

func distance(from: CGFloat, to: CGFloat, percentage: CGFloat) -> CGFloat {
	return from + (to - from) * percentage
}
