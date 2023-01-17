//
//  PhotonAction.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

public extension PhotonAction {
	typealias PhotonActionHandler = (PhotonAction, UITableViewCell) -> Void
	typealias PhotonActionCustomHeight = (PhotonAction) -> CGFloat
	typealias PhotonActionCustomRender = (UIView) -> Void
}

public extension PhotonAction {
	enum IconType {
		case image
		case url
		case none
	}
}

public struct PhotonAction {
	public let title: NSAttributedString
	
	public let iconType: PhotonAction.IconType
	public let iconImage: UIImage?
	public let iconURL: URL?
	
	public var isChecked: Bool
	public var isEnabled: Bool
	
	public let handler: PhotonActionHandler?
	
	public var customHeight: PhotonActionCustomHeight?
	public var customRender: PhotonActionCustomRender?
	
	public init(
		title: NSAttributedString,
		iconType: PhotonAction.IconType = .none,
		iconImage: UIImage? = nil,
		iconURL: URL? = nil,
		isChecked: Bool = false,
		isEnabled: Bool = true,
    handler: PhotonActionHandler? = nil,
		customHeight: PhotonActionCustomHeight? = nil,
		customRender: PhotonActionCustomRender? = nil
	) {
		self.title = title
		self.iconType = iconType
		self.iconImage = iconImage
		self.iconURL = iconURL
		self.isChecked = isChecked
		self.isEnabled = isEnabled
		self.handler = handler
		self.customHeight = customHeight
		self.customRender = customRender
	}
}

extension PhotonAction: Equatable {
	public static func == (lhs: PhotonAction, rhs: PhotonAction) -> Bool {
		return lhs.title.isEqual(to: rhs.title)
	}
}
