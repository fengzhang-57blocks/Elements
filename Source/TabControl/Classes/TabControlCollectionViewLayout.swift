//
//  CollectionViewLayout.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

open class TabControlCollectionViewLayout: UICollectionViewLayout {
	
	public var configurations = TabControlConfigurations()
	
	private let indicatorKind: String = "indicator"
	public var indicatorLayoutAttributes: TabControlIndicatorLayoutAttributes?
	open var indicatorClass: TabControlIndicatorView.Type {
		set { configurations.indicatorClass = newValue }
		get { return configurations.indicatorClass }
	}
	
	override init() {
		super.init()
		configure()
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	public func configure() {
		register(indicatorClass.self, forDecorationViewOfKind: indicatorKind)
	}
	
	open override func prepare() {
		super.prepare()
	}
	
	open override func layoutAttributesForDecorationView(
		ofKind elementKind: String,
		at indexPath: IndexPath
	) -> UICollectionViewLayoutAttributes? {
		switch elementKind {
		case indicatorKind:
			return indicatorLayoutAttributes
		default:
			return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
		}
	}
}
