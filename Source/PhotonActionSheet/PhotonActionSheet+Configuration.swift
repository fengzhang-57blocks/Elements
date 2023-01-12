//
//  PhotonActionSheet+Configuration.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/10.
//

import UIKit

public extension PhotonActionSheet {
	struct Configuration {
		public let spacing: CGFloat
		
		// Only work for Landscape screen.
		public let maxSheetWidth: CGFloat
		public let maxSheetHeight: CGFloat
		
		public let showCloseButton: Bool
		public let closeButtonHeight: CGFloat
		public let separatorRowHeight: CGFloat
		public let actionHeight: CGFloat
		
		public let cornerRadius: CGFloat
		
		public init(
			spacing: CGFloat = 10,
			maxSheetWidth: CGFloat = 370,
			maxSheetHeight: CGFloat = 280,
			showCloseButton: Bool = true,
			closeButtonHeight: CGFloat = 56,
			separatorRowHeight: CGFloat = 13,
			actionHeight: CGFloat = 50,
			cornerRadius: CGFloat = 10
		) {
			self.spacing = spacing
			self.maxSheetHeight = maxSheetHeight
			self.maxSheetWidth = maxSheetWidth
			self.showCloseButton = showCloseButton
			self.closeButtonHeight = closeButtonHeight
			self.separatorRowHeight = separatorRowHeight
			self.actionHeight = actionHeight
			self.cornerRadius = cornerRadius
		}
	}
}

public extension PhotonActionSheet.Configuration {
	static let `default` = PhotonActionSheet.Configuration()
}
