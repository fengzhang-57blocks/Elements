//
//  PagingMenuCollectionViewLayout.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

// https://developer.apple.com/documentation/uikit/uicollectionviewlayout

open class PagingMenuCollectionViewLayout: UICollectionViewLayout {
	
	public var state: PagingState = .empty
	
	public var options = PagingOptions.default()
	
	private let indicatorKind: String = "indicator"
	public private(set) var indicatorLayoutAttributes: PagingMenuIndicatorLayoutAttributes?
	open var indicatorClass: PagingMenuIndicatorView.Type {
		set { options.indicatorClass = newValue }
		get { return options.indicatorClass }
	}
	
	public private(set) var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	
	private var contentSize: CGSize = .zero
	open override var collectionViewContentSize: CGSize {
		return contentSize
	}
	
	public var itemsCache: PagingItemsCache = PagingItemsCache(items: [])
	
  internal var sizeCache: PagingItemSizeCache?
	
	private var view: UICollectionView {
		return collectionView!
	}
  
	override init() {
		super.init()
		configure()
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	open override func prepare() {
		super.prepare()
    
//    layoutAttributes = [:]
//    indicatorLayoutAttributes = nil
		
		createIndicatorLayoutAttributes()
		createCellLayoutAttributes()
    
    updateIndicatorLayoutAttributes()
	}
  
  open override func invalidateLayout() {
    super.invalidateLayout()
  }
  
  open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayout(with: context)
  }
  
  open override func shouldInvalidateLayout(
		forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
		withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
	) -> Bool {
		return false
  }
  
//  open override func invalidationContext(
//    forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
//    withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
//  ) -> UICollectionViewLayoutInvalidationContext {
//
//  }
	
	open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let layoutAttributes = self.layoutAttributes[indexPath] as? PagingMenuCellLayoutAttributes else {
			return nil
		}
		
    layoutAttributes.progress = progressForCellLayoutAttributes(at: layoutAttributes.indexPath)
		return layoutAttributes
	}
  
  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = Array(self.layoutAttributes.values)
    for each in layoutAttributes {
      if let attrs = each as? PagingMenuCellLayoutAttributes {
				attrs.progress = progressForCellLayoutAttributes(at: attrs.indexPath)
      }
    }
    
    if let attrs = layoutAttributesForDecorationView(ofKind: indicatorKind, at: IndexPath(item: 0, section: 0)) {
      layoutAttributes.append(attrs)
    }
    
    return layoutAttributes
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

private extension PagingMenuCollectionViewLayout {
  func createCellLayoutAttributes() {
		guard let sizeCache = sizeCache else {
			return
		}
		
    var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    var previousFrame: CGRect = .zero
    for index in 0..<view.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: index, section: 0)
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			
      let x = previousFrame.maxX
      let y = previousFrame.minY
			
			if sizeCache.implementedSizeDelegate {
				let item = itemsCache.item(for: indexPath)
				var width = sizeCache.widthForItem(item)
				// TODO: caculate width
				if let selectedItem = state.currentItem, selectedItem.isEqual(to: item) {
					
				} else if let destinationItem = state.destinationItem, destinationItem.isEqual(to: item) {
					
				}
				
				attributes.frame = CGRect(x: x, y: y, width: width, height: options.menuItemSize.height)
			} else {
				switch options.menuItemSize {
				case let .fixed(width, height):
					attributes.frame = CGRect(x: x, y: y, width: width, height: height)
				case let .selfSizing(estimatedWidth, height):
					attributes.frame = CGRect(x: x, y: y, width: estimatedWidth, height: height)
				}
			}
      
			layoutAttributes[indexPath] = attributes
      previousFrame = attributes.frame
    }
		
		contentSize = CGSize(width: previousFrame.maxX, height: view.bounds.height)
		
		self.layoutAttributes = layoutAttributes
  }
	
	func createIndicatorLayoutAttributes() {
		if case .visible = options.indicatorOptions, indicatorLayoutAttributes == nil {
			indicatorLayoutAttributes = PagingMenuIndicatorLayoutAttributes(
				forDecorationViewOfKind: indicatorKind,
				with: IndexPath(item: 0, section: 0)
			)
		}
	}
  
  func updateIndicatorLayoutAttributes() {
    guard let indicatorLayoutAttributes = indicatorLayoutAttributes else {
      return
    }
    
    indicatorLayoutAttributes.configure(with: options)
    
    if let fromItem = state.currentItem {
      if let currentIndexPath = itemsCache.indexPath(for: fromItem),
          let upcomingInexPath = upcomingIndexPath(for: currentIndexPath) {
        let from = PagingMenuItemLayout(frame: indicatorFrame(for: currentIndexPath))
        let to = PagingMenuItemLayout(frame: indicatorFrame(for: upcomingInexPath))
        let progress = abs(state.progress)
        indicatorLayoutAttributes.updateSize(from: from, to: to, progress: progress)
      }
    }
  }
}

private extension PagingMenuCollectionViewLayout {
  func upcomingIndexPath(for indexPath: IndexPath) -> IndexPath? {
		if let toItem = state.destinationItem,
			 let upcomingIndexPath = itemsCache.indexPath(for: toItem) {
			return upcomingIndexPath
    }
		
		if indexPath.item == (0..<view.numberOfSections).lowerBound {
			return IndexPath(item: indexPath.item + 1, section: 0)
		}
		
		if indexPath.item == (0..<view.numberOfSections).upperBound {
			return IndexPath(item: indexPath.item - 1, section: 0)
		}
		
    return indexPath
  }
	
	func indicatorFrame(for indexPath: IndexPath) -> CGRect {
		guard let attributes = self.layoutAttributes[indexPath] else {
			return .zero
		}
		
		return attributes.frame
	}
}

private extension PagingMenuCollectionViewLayout {
	func configure() {
		register(indicatorClass.self, forDecorationViewOfKind: indicatorKind)
	}
	
	func progressForCellLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
		guard let _ = state.currentItem else {
			return 0
		}
		
		return 0
	}
}
