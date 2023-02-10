//
//  NSAttributedStringExtensions.swift
//  Elements
//
//  Created by 57block on 2023/1/6.
//

import Foundation
import UIKit

public extension NSAttributedString {
	func boundingRectSize(_ size: CGSize) -> CGSize {
		return self.boundingRect(
			with: size,
			options: [.usesLineFragmentOrigin, .usesFontLeading],
			context: nil
		).size
	}
}
