//
//  PagingViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

extension PagingViewController {
  enum DataSourceReference {
    case finite(PagingViewControllerFiniteDataSource)
    case `static`(PagingViewControllerStaticDataSource)
		case none
  }
}

open class PagingViewController: UIViewController {
  
  // MARK: Public Props
  
  public private(set) var options: PagingOptions
  public private(set) var state: PagingState {
    didSet {
      collectionViewLayout.state = state
    }
  }
  
  weak open var delegate: PagingViewControllerDelegate?
  weak open var sizeDelegate: PagingViewControllerSizeDelegate?
  weak open var infiniteDataSource: PagingViewControllerDynamicDataSource?
  weak open var dataSource: PagingViewControllerDataSource? {
    didSet {
      configureFiniteDataSource()
    }
  }
  
	public private(set) var pageViewController: PageViewController
	
  public private(set) var collectionViewLayout: PagingCollectionViewLayout
  
  public private(set) var viewControllers: [UIViewController]?
	
  public private(set) var visibleItems: PagingItems {
    didSet {
      collectionViewLayout.visibleItems = visibleItems
    }
  }
  
  public let collectionView: UICollectionView
  
  // MARK: Private Props
  
  private(set) var sizeCache: PagingItemSizeCache {
    didSet {
      collectionViewLayout.sizeCache = sizeCache
    }
  }
	
	private var dataSourceReference: DataSourceReference = .none
  
  private var didLayoutSubviews: Bool = false
	
	public init(options: PagingOptions = PagingOptions()) {
		self.options = options
		state = .empty
    visibleItems = PagingItems(items: [])
		sizeCache = PagingItemSizeCache(options: options)
		collectionViewLayout = PagingCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
		super.init(nibName: nil, bundle: nil)
		configure()
    
    register(PagingTitleCell.self, for: PagingIndexItem.self)
	}
  
  public convenience init(
    options: PagingOptions = PagingOptions(),
    viewControllers: [UIViewController]
  ) {
    self.init(options: options)
    configureStaticDataSource()
  }
	
	public required init?(coder: NSCoder) {
		options = PagingOptions()
		state = .empty
    visibleItems = PagingItems(items: [])
		sizeCache = PagingItemSizeCache(options: options)
		collectionViewLayout = PagingCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
		super.init(coder: coder)
		configure()
    
    register(PagingTitleCell.self, for: PagingIndexItem.self)
	}
	
	open var pagingView: PagingView {
		return view as! PagingView
	}
	
	open override func loadView() {
		view = PagingView(
			collectionView: collectionView,
			pageView: pageViewController.view,
			options: options
		)
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		addChild(pageViewController)
    pagingView.createLayout()
		pageViewController.didMove(toParent: self)
    
    pageViewController.delegate = self
		pageViewController.dataSource = self
	}
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !didLayoutSubviews {
      didLayoutSubviews = true
      switch state {
      case let .selected(item), let .scrolling(_, item?, _, _, _):
        state = .selected(item: item)
        reloadItems(around: item)
				selectItem(item, direction: .none, animated: false)
        collectionView.selectItem(
          at: visibleItems.indexPath(for: item),
          animated: false,
          scrollPosition: .centeredHorizontally
        )
      default:
        break
      }
    }
  }
}

// MARK: Public Functions

public extension PagingViewController {
  func register(_ cellClass: AnyClass?, for item: PagingItem.Type) {
    collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: item))
  }
  
  func register(_ nib: UINib?, for item: PagingItem.Type) {
    collectionView.register(nib, forCellWithReuseIdentifier: String(describing: item))
  }
  
  func selectItem(_ item: PagingItem, animated: Bool) {
    if collectionView.superview == nil || collectionView.window == nil {
      state = .selected(item: item)
      return
    }

    switch state {
    case .empty:
      state = .selected(item: item)
      reloadItems(around: item)
			selectItem(item, direction: .none, animated: false)
      collectionView.selectItem(
        at: visibleItems.indexPath(for: item),
        animated: false,
        scrollPosition: .centeredHorizontally
      )
    case let .selected(currentItem) where !currentItem.isEqual(to: item):
      if animated {
        state = .scrolling(
          fromItem: currentItem,
          toItem: item,
          initialContentOffset: collectionView.contentOffset,
          distance: 0,
          progress: 0
        )
				selectItem(
					item,
					direction: visibleItems.direction(from: currentItem, to: item),
					animated: animated
				)
      } else {
        state = .selected(item: item)
        reloadItems(around: item)
				selectItem(item, direction: .none, animated: animated)
        collectionView.selectItem(
          at: visibleItems.indexPath(for: item),
          animated: animated,
          scrollPosition: .centeredHorizontally
        )
      }
    default:
      break
    }
  }
  
  func selectIndex(_ index: Int, animated: Bool) {
    switch dataSourceReference {
    case let .static(dataSource):
      selectItem(dataSource.itemForIndex(index), animated: animated)
    case let .finite(dataSource):
      selectItem(dataSource.itemForIndex(index), animated: animated)
    case .none:
      fatalError("selectIndex(_:animated:): You need to implement the dataSource.")
    }
  }
  
  func reloadData() {
    var items: [PagingItem] = []
    switch dataSourceReference {
    case let .static(dataSource):
      dataSource.reloadItems()
      items = dataSource.items
    case let .finite(dataSource):
      items = itemsForFiniteDataSource()
      dataSource.updateItems(items)
    case .none:
      break
    }
    
    if let currentItem = state.currentItem {
      if let item = items.first(where: { $0.isEqual(to: currentItem) }) {
        removeContent()
        selectItem(item, direction: .none, animated: false)
        state = .selected(item: item)
        collectionViewLayout.invalidateLayout()
      }
    } else if let firstItem = items.first {
      state = .selected(item: firstItem)
    } else {
      resetState()
    }
  }
}

// MARK: Private Functions

private extension PagingViewController {
	func configure() {
		collectionViewLayout.state = state
		collectionViewLayout.sizeCache = sizeCache
		
		collectionView.contentInsetAdjustmentBehavior = .never

		collectionView.delegate = self
		collectionView.dataSource = self
	}
	
  func configureFiniteDataSource() {
    let items = itemsForFiniteDataSource()
    let dataSource = PagingViewControllerFiniteDataSource(items: items)
    dataSource.viewControllerForIndex = { [unowned self] index in
      self.dataSource?.pagingViewController(self, viewControllerAt: index)
    }
    dataSourceReference = .finite(dataSource)
    infiniteDataSource = dataSource
    
    if let firstItem = dataSource.items.first {
      selectItem(firstItem, animated: false)
    }
  }
  
  func configureStaticDataSource() {
    guard let viewControllers = viewControllers else {
      return
    }
		
    let dataSource = PagingViewControllerStaticDataSource(viewControllers: viewControllers)
    dataSourceReference = .static(dataSource)
    infiniteDataSource = dataSource
    
    if let firstItem = dataSource.items.first {
      selectItem(firstItem, animated: false)
    }
  }
  
  func item(before item: PagingItem) -> PagingItem? {
    return infiniteDataSource?.pagingViewController(self, itemBefore: item)
  }
  
  func item(after item: PagingItem) -> PagingItem? {
    return infiniteDataSource?.pagingViewController(self, itemAfter: item)
  }
  
	func selectItem(_ item: PagingItem, direction: PagingTransitionDirection, animated: Bool) {
    guard let dataSource = infiniteDataSource else {
      return
    }
    
    let viewController = dataSource.pagingViewController(self, viewControllerFor: item)
    pageViewController.selectViewController(
      viewController,
      direction: direction,
      animated: animated
    )
  }
  
  func updateScrollingState(
    fromItem: PagingItem,
    toItem: PagingItem?,
    initialContentOffset: CGPoint,
    distance: CGFloat,
    progress: CGFloat
  ) {
    state = .scrolling(
      fromItem: fromItem,
      toItem: toItem,
      initialContentOffset: initialContentOffset,
      distance: distance,
      progress: progress
    )
    
    if .scrollAlongside == options.menuTransitionBehaviour {
      let invalidationContext = PagingInvalidationContext()
      if let _ = toItem {
        if collectionView.contentSize.width > collectionView.bounds.width,
					 state.progress != 0 {
          collectionView.setContentOffset(
            CGPoint(
              x: initialContentOffset.x + distance * abs(progress),
              y: initialContentOffset.y
            ),
            animated: false
          )
        }
       
        if sizeCache.implementedSizeDelegate {
          invalidationContext.invalidateSizes = true
        }
      }
      collectionViewLayout.invalidateLayout(with: invalidationContext)
    }
  }
  
  func calculateTransitionDistance(from fromItem: PagingItem, to item: PagingItem?) -> PagingTransitionLayout? {
    guard let toItem = item else {
      return nil
    }

		return PagingTransitionLayout(
			fromItem: fromItem,
			toItem: toItem,
			collectionView: collectionView,
			layoutAttributes: collectionViewLayout.layoutAttributes,
			sizeCache: sizeCache,
			visibleItems: visibleItems
		)
  }
  
  func itemsForFiniteDataSource() -> [PagingItem] {
    guard let dataSource = dataSource else {
      return []
    }
    
    var items: [PagingItem] = []
    for index in 0..<dataSource.numberOfViewControllers(in: self) {
      items.append(dataSource.pagingViewController(self, pagingItemAt: index))
    }
    
    return items
  }
  
  func reloadItems(around item: PagingItem) {
    let items = generateItems(around: item)

    let prevContentOffset = collectionView.contentOffset

    visibleItems = PagingItems(items: items)
    
    collectionView.reloadData()
    collectionViewLayout.prepare()
		
		// FIXME: offset
    
    let offset: CGFloat = 0

    collectionView.setContentOffset(
      CGPoint(
        x: prevContentOffset.x + offset,
        y: prevContentOffset.y
      ),
      animated: false
    )

    collectionView.layoutIfNeeded()

    if case let .scrolling(fromItem, toItem, _, distance, progress) = state {
			let contentOffset = collectionView.contentOffset
			let transitionDistance = calculateTransitionDistance(from: fromItem, to: toItem)?.distance ?? .zero
			let newContentOffset = CGPoint(
				x: contentOffset.x - (distance - transitionDistance),
				y: 0
			)
      state = .scrolling(
        fromItem: fromItem,
        toItem: toItem,
        initialContentOffset: newContentOffset,
        distance: distance,
        progress: progress
      )
    }
  }
  
  func generateItems(around item: PagingItem) -> [PagingItem] {
    var items: [PagingItem] = [item]

    let menuWidth = collectionView.bounds.width
    var prevBeforeItem = item
    var prevAfterItem = item
    
    var widthBefore = menuWidth
    while widthBefore > 0 {
      if let beforeItem = infiniteDataSource?.pagingViewController(self, itemBefore: prevBeforeItem) {
        widthBefore -= itemWidth(for: beforeItem)
        widthBefore -= options.itemSpacing
        items.insert(beforeItem, at: 0)
        prevBeforeItem = beforeItem
      } else {
        break
      }
    }
    
    var widthAfter = menuWidth + widthBefore
    while widthAfter > 0 {
      if let afterItem = infiniteDataSource?.pagingViewController(self, itemAfter: prevAfterItem) {
        widthAfter -= itemWidth(for: afterItem)
        widthAfter -= options.itemSpacing
        items.append(afterItem)
        prevAfterItem = afterItem
      } else {
        break
      }
    }
    
    var remainingWidth = widthAfter
    while remainingWidth > 0 {
      if let beforeItem = infiniteDataSource?.pagingViewController(self, itemBefore: prevBeforeItem) {
        remainingWidth -= itemWidth(for: beforeItem)
        items.insert(beforeItem, at: 0)
        prevBeforeItem = beforeItem
      } else {
        break
      }
    }
    
    return items
  }
  
  func itemWidth(for item: PagingItem) -> CGFloat {
    guard let currentItem = state.currentItem else {
      return options.estimatedItemWidth
    }
    
    if item.isEqual(to: currentItem) {
      return sizeCache.widthForSelectedItem(currentItem)
    }
    
    return sizeCache.widthForItem(item)
  }
  
  func removeContent() {
    pageViewController.removeAllPages()
  }
	
	func resetState() {
		state = .empty
		sizeCache.clearCahces()
    visibleItems = PagingItems(items: [])
		collectionView.reloadData()
    removeContent()
	}
}

// MARK: UICollectionViewDataSource

extension PagingViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return visibleItems.items.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = visibleItems.item(for: indexPath)
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: type(of: item)),
      for: indexPath) as! PagingCell
    var isSelected = false
    if let currentItem = state.currentItem {
      isSelected = currentItem.isEqual(to: item)
    }
    cell.setItem(item, selected: isSelected, options: options)
    return cell
  }
}

// MARK: UICollectionViewDelegate

extension PagingViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = visibleItems.item(for: indexPath)
    delegate?.pagingViewController(self, didSelectItem: item)
    selectItem(item, animated: true)
  }
}

// MARK: UIScrollViewDelegate

extension PagingViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard !collectionView.indexPathsForVisibleItems.isEmpty else {
      return
    }
    
    let contentInsets = collectionViewLayout.contentInsets
    if collectionView.closeTo(edge: .left, offset: contentInsets.left) {
      if let firstItem = visibleItems.items.first,
         let _ = item(before: firstItem) {
        reloadItems(around: firstItem)
      }
    } else if collectionView.closeTo(edge: .right, offset: contentInsets.right) {
      if let lastItem = visibleItems.items.last,
         let _ = item(after: lastItem) {
        reloadItems(around: lastItem)
      }
    }
  }
}

// MARK: PageViewControllerDataSource

extension PagingViewController: PageViewControllerDataSource {
  public func pageViewController(_ pageViewController: PageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let dataSource = infiniteDataSource,
          let currentItem = state.currentItem,
          let item = dataSource.pagingViewController(self, itemBefore: currentItem) else {
      return nil
    }
    
    return dataSource.pagingViewController(self, viewControllerFor: item)
  }
  
  public func pageViewController(_ pageViewController: PageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let dataSource = infiniteDataSource,
					let currentItem = state.currentItem,
					let item = dataSource.pagingViewController(self, itemAfter: currentItem) else {
      return nil
    }
    
    return dataSource.pagingViewController(self, viewControllerFor: item)
  }
}

// MARK: PageViewControllerDelegate

extension PagingViewController: PageViewControllerDelegate {
	public func pageViewController(
		_ pageViewController: PageViewController,
		willBeginScrollFrom startViewController: UIViewController,
		to destinationViewController: UIViewController
	) {
    delegate?.pagingViewController(
      self,
      willBeginScrollFrom: startViewController,
      to: destinationViewController
    )
	}
	
  public func pageViewController(
    _ pageViewController: PageViewController,
    isScrollingFrom startViewController: UIViewController,
    to destinationViewController: UIViewController,
    with progress: CGFloat
  ) {
    switch state {
    case let .selected(currentItem):
      var toItem: PagingItem?
      if progress > 0 {
        toItem = item(after: currentItem)
      } else if progress < 0 {
        toItem = item(before: currentItem)
      } else {
        return
      }
			
			// FIXME: calculate content offset
      
      let transitionDistance = calculateTransitionDistance(from: currentItem, to: toItem)

      updateScrollingState(
        fromItem: currentItem,
        toItem: toItem,
        initialContentOffset: transitionDistance?.contentOffset ?? .zero,
        distance: transitionDistance?.distance ?? 0,
        progress: progress
      )
    case let .scrolling(fromItem, toItem, initialContentOffset, distance, prevProgress):
      if prevProgress < 0, progress > 0 {
        state = .selected(item: fromItem)
      } else if prevProgress > 0, progress < 0 {
        state = .selected(item: fromItem)
      } else if progress == 0 {
        state = .selected(item: fromItem)
      } else {
        updateScrollingState(
          fromItem: fromItem,
          toItem: toItem,
          initialContentOffset: initialContentOffset,
          distance: distance,
          progress: progress
        )
      }
    default:
      break
    }
		
		delegate?.pagingViewController(self, isScrollingFrom: startViewController, to: destinationViewController)
  }
	
  public func pageViewController(
    _ pageViewController: PageViewController,
    didEndScrollFrom startViewController: UIViewController,
    to destinationViewController: UIViewController,
    transitionSuccessful successful: Bool
  ) {
    if successful,
       case let .scrolling(fromItem, toItem, _, _, _) = state {
      if let toItem = toItem {
        state = .selected(item: toItem)
        
        if !collectionView.isDragging {
          reloadItems(around: toItem)
          collectionView.selectItem(
            at: visibleItems.indexPath(for: toItem),
            animated: options.menuTransitionBehaviour == .scrollAlongside,
            scrollPosition: .centeredHorizontally
          )
        }
      } else {
        state = .selected(item: fromItem)
      }
    }
    
    delegate?.pagingViewController(
      self,
      didEndScrollFrom: startViewController,
      to: destinationViewController,
      transitionSuccessful: successful
    )
  }
}
