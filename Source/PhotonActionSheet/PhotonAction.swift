//
//  PhotonAction.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

extension PhotonAction {
	typealias PhotonActionCustomHeight = (_ action: PhotonAction) -> CGFloat
	typealias PhotonActionCustomRender = (_ contentView: UIView) -> Void
	typealias PhotonActionHandler = (_ action: PhotonAction, _ cell: UITableViewCell) -> Void
}

extension PhotonAction {
	enum IconType {
		case image
		case url
		case none
	}
}

struct PhotonAction {
	let title: NSAttributedString
	
	let iconType: PhotonAction.IconType
	let iconImage: UIImage?
	let iconURL: URL?
	
	var isSelected: Bool
	var isEnabled: Bool
	
	var customHeight: PhotonActionCustomHeight?
	var customRender: PhotonActionCustomRender?
	let actionHandler: PhotonActionHandler?
	
	init(
		title: NSAttributedString,
		iconType: PhotonAction.IconType = .none,
		iconImage: UIImage? = nil,
		iconURL: URL? = nil,
		isSelected: Bool = false,
		isEnabled: Bool = true,
		customHeight: PhotonActionCustomHeight? = nil,
		customRender: PhotonActionCustomRender? = nil,
    actionHandler: PhotonActionHandler? = nil
	) {
		self.title = title
		self.iconType = iconType
		self.iconImage = iconImage
		self.iconURL = iconURL
		self.isSelected = isSelected
		self.isEnabled = isEnabled
		self.customHeight = customHeight
		self.customRender = customRender
		self.actionHandler = actionHandler
	}
}

extension PhotonAction: Equatable {
	static func == (lhs: PhotonAction, rhs: PhotonAction) -> Bool {
		return lhs.title.isEqual(to: rhs.title)
	}
}
