//
//  PagingCollectionViewLayout.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

// https://developer.apple.com/documentation/uikit/uicollectionviewlayout

open class PagingCollectionViewLayout: UICollectionViewLayout {

	public var state: PagingState = .empty

  public var options = PagingOptions() {
    didSet {
      optionsChanged(oldValue: oldValue)
    }
  }

	private let indicatorKind: String = "indicator"
	public private(set) var indicatorLayoutAttributes: PagingIndicatorLayoutAttributes?
	open var indicatorClass: PagingIndicatorView.Type {
		set { options.indicatorClass = newValue }
		get { return options.indicatorClass }
	}
  
  private let borderKind: String = "border"
  public private(set) var borderLayoutAttributes: PagingBorderLayoutAttributes?
  open var borderClass: PagingBorderView.Type {
    set { options.borderClass = newValue }
    get { return options.borderClass }
  }

	public private(set) var layoutAttributes: [IndexPath: PagingCellLayoutAttributes] = [:]

	private var contentSize: CGSize = .zero
  public private(set) var contentInsets: UIEdgeInsets = .zero
	open override var collectionViewContentSize: CGSize {
    return contentSize
  }
  
  private var menuInsets: UIEdgeInsets {
    return UIEdgeInsets(
      top: options.menuInsets.top,
      left: options.menuInsets.left + safeAreaInsets.left,
      bottom: options.menuInsets.bottom,
      right: options.menuInsets.right + safeAreaInsets.right
    )
  }
  
  private var safeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
      return view.safeAreaInsets
    }
    return .zero
  }

	public var visibleItems: PagingItems = PagingItems(items: [])

  internal var sizeCache: PagingItemSizeCache?
  private var preferredSizeCache: [Int: CGFloat] = [:]
  
  private var invalidateKind: PagingInvalidateKind = .nothing

  private var range: Range<Int> {
    return 0..<view.numberOfItems(inSection: 0)
  }

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
    
    switch invalidateKind {
    case .everything:
      layoutAttributes = [:]
      indicatorLayoutAttributes = nil
      borderLayoutAttributes = nil
      createLayoutAttributes()
      createDecorationLayoutAttributes()
    case .size:
      layoutAttributes = [:]
      createLayoutAttributes()
    case .nothing:
      break
    }

    updateIndicatorLayoutAttributes()
    updateBorderLayoutAttributes()
    
    invalidateKind = .nothing
	}

  open override func invalidateLayout() {
    super.invalidateLayout()
    invalidateKind = .everything
  }

  open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayout(with: context)
    invalidateKind = PagingInvalidateKind(from: context)
  }

  open override func shouldInvalidateLayout(
		forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
		withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
	) -> Bool {
    switch options.itemSize {
    case .selfSizing where originalAttributes is PagingCellLayoutAttributes:
      if originalAttributes.frame.width != preferredAttributes.frame.width {
        let item = visibleItems.item(for: originalAttributes.indexPath)
        preferredSizeCache[item.identifier] = preferredAttributes.frame.width
        return true
      }
      return false
    default:
      return false
    }
  }

  open override func invalidationContext(
    forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
    withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutInvalidationContext {
    let context = PagingInvalidationContext()
    context.invalidateSizes = true
    return context
  }

	open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let attrs = self.layoutAttributes[indexPath] else {
			return nil
		}

    attrs.progress = progressForLayoutAttributes(at: attrs.indexPath)
		return attrs
	}

  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes: [UICollectionViewLayoutAttributes] = Array(self.layoutAttributes.values)
    for attrs in layoutAttributes {
      if let attrs = attrs as? PagingCellLayoutAttributes {
				attrs.progress = progressForLayoutAttributes(at: attrs.indexPath)
      }
    }

    let indexPath = IndexPath(item: 0, section: 0 )
    if let attrs = layoutAttributesForDecorationView(ofKind: indicatorKind, at: indexPath) {
      layoutAttributes.append(attrs)
    }
    
    if let attrs = layoutAttributesForDecorationView(ofKind: borderKind, at: indexPath) {
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
    case borderKind:
      return borderLayoutAttributes
		default:
			return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
		}
	}
}

private extension PagingCollectionViewLayout {
  func createLayoutAttributes() {
		guard let sizeCache = sizeCache else {
			return
		}

    var layoutAttributes: [IndexPath: PagingCellLayoutAttributes] = [:]

    var previousFrame: CGRect = .zero
    previousFrame.origin.x = menuInsets.left + safeAreaInsets.left
    previousFrame.origin.y = menuInsets.top
    
    for index in range {
      let indexPath = IndexPath(item: index, section: 0)
			let attributes = PagingCellLayoutAttributes(forCellWith: indexPath)
      
      let item = visibleItems.item(for: indexPath)

      let x = previousFrame.maxX
      let y = previousFrame.minY

			if sizeCache.implementedSizeDelegate {
				var width = sizeCache.widthForItem(item)
        let selectedWidth = sizeCache.widthForSelectedItem(item)
				if let selectedItem = state.currentItem, selectedItem.isEqual(to: item) {
          width = distance(from: selectedWidth, to: width, percentage: abs(state.progress))
				} else if let destinationItem = state.destinationItem, destinationItem.isEqual(to: item) {
          width = distance(from: width, to: selectedWidth, percentage: abs(state.progress))
				}

				attributes.frame = CGRect(x: x, y: y, width: width, height: options.itemSize.height)
			} else {
				switch options.itemSize {
				case let .fixed(width, height):
					attributes.frame = CGRect(x: x, y: y, width: width, height: height)
        case let .sizeToFit(minWidth, height):
          attributes.frame = CGRect(x: x, y: y, width: minWidth, height: height)
				case let .selfSizing(estimatedWidth, height):
          if let actualSize = preferredSizeCache[item.identifier] {
            attributes.frame = CGRect(x: x, y: y, width: actualSize, height: height)
          } else {
            attributes.frame = CGRect(x: x, y: y, width: estimatedWidth, height: height)
          }
				}
			}

			layoutAttributes[indexPath] = attributes
      previousFrame = attributes.frame
    }
    
    if previousFrame.maxX - menuInsets.left < view.bounds.width {
      switch options.itemSize {
      case let .sizeToFit(_, height) where sizeCache.implementedSizeDelegate == false:
        previousFrame = .zero
        previousFrame.origin.x = menuInsets.left
        let width = (view.bounds.width - menuInsets.horizontal - options.itemSpacing * CGFloat(range.upperBound - 1)) / CGFloat(range.upperBound)
        for attrs in layoutAttributes.values.sorted(by: { $0.indexPath < $1.indexPath }) {
          attrs.frame = CGRect(
            x: previousFrame.maxX + options.itemSpacing,
            y: menuInsets.top,
            width: width,
            height: height
          )
          previousFrame = attrs.frame
        }
      default:
        if case .centeredHorizontally = options.menuScrollPosition {
          for attrs in layoutAttributes.values.sorted(by: { $0.indexPath < $1.indexPath }) {
            let offset = (view.bounds.width - previousFrame.maxX - menuInsets.left) / 2
            attrs.frame = attrs.frame.offsetBy(dx: offset, dy: 0)
          }
        }
      }
    }

    contentSize = CGSize(
      width: previousFrame.maxX + menuInsets.right,
      height: view.bounds.height
    )

		self.layoutAttributes = layoutAttributes
  }

	func createDecorationLayoutAttributes() {
		if case .visible = options.indicatorOptions,
       indicatorLayoutAttributes == nil {
			indicatorLayoutAttributes = PagingIndicatorLayoutAttributes(
				forDecorationViewOfKind: indicatorKind,
				with: IndexPath(item: 0, section: 0)
			)
		}
    
    if case .visible = options.borderOptions,
       borderLayoutAttributes == nil {
      borderLayoutAttributes = PagingBorderLayoutAttributes(
        forDecorationViewOfKind: borderKind,
        with: IndexPath(item: 0, section: 0)
      )
    }
	}
  
  func updateIndicatorLayoutAttributes() {
    guard let attrs = indicatorLayoutAttributes else {
      return
    }

    attrs.configure(with: options)

    if let fromItem = state.currentItem {
      if let currentIndexPath = visibleItems.indexPath(for: fromItem),
         let upcomingInexPath = upcomingIndexPath(for: currentIndexPath) {
        let from = PagingIndicatorMetric(options: options.indicatorOptions, frame: indicatorFrameForIndex(at: currentIndexPath.item))
        let to = PagingIndicatorMetric(options: options.indicatorOptions, frame: indicatorFrameForIndex(at: upcomingInexPath.item))
        let progress = abs(state.progress)
        attrs.update(from: from, to: to, progress: progress)
      }
    }
  }
  
  func updateBorderLayoutAttributes() {
    guard let attrs = borderLayoutAttributes else {
      return
    }

    attrs.configure(with: options)
    attrs.update(from: view.bounds, contentSize: contentSize)
  }
}

private extension PagingCollectionViewLayout {
  func upcomingIndexPath(for indexPath: IndexPath) -> IndexPath? {
		if let toItem = state.destinationItem,
			 let upcomingIndexPath = visibleItems.indexPath(for: toItem) {
			return upcomingIndexPath
    }

		if indexPath.item == range.lowerBound {
			return IndexPath(item: indexPath.item - 1, section: 0)
		}

		if indexPath.item == range.upperBound - 1 {
			return IndexPath(item: indexPath.item + 1, section: 0)
		}

    return indexPath
  }
  
  func optionsChanged(oldValue: PagingOptions) {
    var shouldInvalidateLayout = false
    
    if oldValue.indicatorClass != options.indicatorClass {
      shouldInvalidateLayout = true
      registerIndicatorClass()
    }
    
    if oldValue.borderClass != options.borderClass {
      shouldInvalidateLayout = true
      registerBorderClass()
    }
    
    if shouldInvalidateLayout {
      invalidateLayout()
    }
  }
  
  func progressForLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
    guard let currentItem = state.currentItem else {
      return 0
    }
    
    let currentIndexPath = visibleItems.indexPath(for: currentItem)
    
    if let currentIndexPath = currentIndexPath {
      if currentIndexPath.item == indexPath.item {
        return 1 - abs(state.progress)
      }
    }
    
    if let currentIndexPath = currentIndexPath,
       let upcomingIndexPath = upcomingIndexPath(for: currentIndexPath) {
      if upcomingIndexPath.item == indexPath.item {
        return abs(state.progress)
      }
    }
    
    return 0
  }

	func indicatorFrameForIndex(at index: Int) -> CGRect {
    if index < range.lowerBound {
      let frame = frameForIndex(at: 0)
      return frame.offsetBy(dx: -frame.width, dy: 0)
    } else if index > range.upperBound - 1 {
      let frame = frameForIndex(at: visibleItems.items.count - 1)
      return frame.offsetBy(dx: -frame.width, dy: 0)
    }

    return frameForIndex(at: index)
	}
  
  func frameForIndex(at index: Int) -> CGRect {
    let indexPath = IndexPath(item: index, section: 0)
    guard let sizeCache = sizeCache,
          let attrs = self.layoutAttributes[indexPath] else {
      return .zero
    }
    
    var frame = CGRect(
      x: attrs.center.x - attrs.bounds.midX,
      y: attrs.center.y - attrs.bounds.midY,
      width: attrs.bounds.width,
      height: attrs.bounds.height
    )

    if sizeCache.implementedSizeDelegate {
      let item = visibleItems.item(for: indexPath)
      frame.size.width = sizeCache.widthForItem(item)
    }
    
    return frame
  }
  
  func registerIndicatorClass() {
    register(indicatorClass.self, forDecorationViewOfKind: indicatorKind)
  }
  
  func registerBorderClass() {
    register(borderClass.self, forDecorationViewOfKind: borderKind)
  }
  
  func configure() {
    registerIndicatorClass()
    registerBorderClass()
  }
}
