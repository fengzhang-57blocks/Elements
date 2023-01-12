//
//  PhotonAction.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

public extension PhotonAction {
	typealias PhotonActionCustomHeight = (_ action: PhotonAction) -> CGFloat
	typealias PhotonActionCustomRender = (_ contentView: UIView) -> Void
	typealias PhotonActionHandler = (_ action: PhotonAction, _ cell: UITableViewCell) -> Void
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
	
	public var isSelected: Bool
	public var isEnabled: Bool
	
	public var customHeight: PhotonActionCustomHeight?
	public var customRender: PhotonActionCustomRender?
	public let handler: PhotonActionHandler?
	
	public init(
		title: NSAttributedString,
		iconType: PhotonAction.IconType = .none,
		iconImage: UIImage? = nil,
		iconURL: URL? = nil,
		isSelected: Bool = false,
		isEnabled: Bool = true,
		customHeight: PhotonActionCustomHeight? = nil,
		customRender: PhotonActionCustomRender? = nil,
    handler: PhotonActionHandler? = nil
	) {
		self.title = title
		self.iconType = iconType
		self.iconImage = iconImage
		self.iconURL = iconURL
		self.isSelected = isSelected
		self.isEnabled = isEnabled
		self.customHeight = customHeight
		self.customRender = customRender
		self.handler = handler
	}
}

extension PhotonAction: Equatable {
	public static func == (lhs: PhotonAction, rhs: PhotonAction) -> Bool {
		return lhs.title.isEqual(to: rhs.title)
	}
}
