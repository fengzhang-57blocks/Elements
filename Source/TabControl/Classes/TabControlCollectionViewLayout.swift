//
//  CollectionViewLayout.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

open class TabControlCollectionViewLayout: UICollectionViewLayout {
	
	public var options = TabControlOptions()
	
	private let indicatorKind: String = "indicator"
	public private(set) var indicatorLayoutAttributes: TabIndicatorLayoutAttributes?
	open var indicatorClass: TabIndicatorView.Type {
		set { options.indicatorClass = newValue }
		get { return options.indicatorClass }
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
    
    indicatorLayoutAttributes = nil
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
