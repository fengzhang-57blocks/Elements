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
	
  public private(set) var collectionViewLayout: PagingMenuCollectionViewLayout
  
  public let collectionView: UICollectionView
  
  public private(set) var viewControllers: [UIViewController]?
	
  public private(set) var itemsCache: PagingItemsCache {
    didSet {
      collectionViewLayout.itemsCache = itemsCache
    }
  }
  
  private(set) var sizeCache: PagingItemSizeCache {
    didSet {
      collectionViewLayout.sizeCache = sizeCache
    }
  }
  
  private var didLayoutSubviews: Bool = false
  
  private var dataSourceReference: DataSourceReference = .none
	
	public init(options: PagingOptions = PagingOptions()) {
		self.options = options
		state = .empty
		itemsCache = PagingItemsCache(items: [])
		sizeCache = PagingItemSizeCache(options: options)
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
		super.init(nibName: nil, bundle: nil)
		configure()
    
    register(PagingMenuTitleCell.self, for: PagingIndexItem.self)
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
		itemsCache = PagingItemsCache(items: [])
		sizeCache = PagingItemSizeCache(options: options)
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
		super.init(coder: coder)
		configure()
    
    register(PagingMenuTitleCell.self, for: PagingIndexItem.self)
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
				selectItem(item, direction: .none, animated: false)
        collectionView.selectItem(
          at: itemsCache.indexPath(for: item),
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
			selectItem(item, direction: .none, animated: false)
      collectionView.selectItem(
        at: itemsCache.indexPath(for: item),
        animated: false,
        scrollPosition: .centeredHorizontally
      )
    case let .selected(currentSelectedItem) where !currentSelectedItem.isEqual(to: item):
      if animated {
        state = .scrolling(
          fromItem: currentSelectedItem,
          toItem: item,
          initialContentOffset: collectionView.contentOffset,
          distance: 0,
          progress: 0
        )
				selectItem(
					item,
					direction: itemsCache.direction(from: currentSelectedItem, to: item),
					animated: animated
				)
      } else {
        state = .selected(item: item)
				selectItem(item, direction: .none, animated: animated)
        collectionView.selectItem(
          at: itemsCache.indexPath(for: item),
          animated: animated,
          scrollPosition: .centeredHorizontally
        )
      }
    default:
      break
    }
    
//    collectionView.reloadData()
    collectionViewLayout.prepare()
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
      items = allPagingMenuItems()
      dataSource.updateItems(items)
    case .none:
      break
    }
    
    if let prevSelectedItem = state.currentItem {
      if let selectedItem = items.first(where: { $0.isEqual(to: prevSelectedItem) }) {
        state = .selected(item: selectedItem)
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
    let items = allPagingMenuItems()
		itemsCache = PagingItemsCache(items: items)
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
		itemsCache = PagingItemsCache(items: dataSource.items)
    dataSourceReference = .static(dataSource)
    infiniteDataSource = dataSource
    
    if let firstItem = dataSource.items.first {
      selectItem(firstItem, animated: false)
    }
  }
  
  func allPagingMenuItems() -> [PagingItem] {
    guard let dataSource = dataSource else {
      return []
    }
    
    var items: [PagingItem] = []
    for index in 0..<dataSource.numberOfViewControllers(in: self) {
      items.append(dataSource.pagingViewController(self, pagingItemAt: index))
    }
    
    return items
  }
  
  func item(before item: PagingItem) -> PagingItem? {
    return infiniteDataSource?.pagingViewController(self, itemBefore: item)
  }
  
  func item(after item: PagingItem) -> PagingItem? {
    return infiniteDataSource?.pagingViewController(self, itemAfter: item)
  }
  
	func selectItem(_ item: PagingItem, direction: PagingDirection, animated: Bool) {
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
    with fromItem: PagingItem,
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
      let invalidationContext = PagingMenuInvalidationContext()
      if let _ = toItem, sizeCache.implementedSizeDelegate {
				invalidationContext.invalidateSize = true
      }
      collectionViewLayout.invalidateLayout(with: invalidationContext)
    }
  }
	
	func resetState() {
		state = .empty
		sizeCache.clearCahces()
		itemsCache = PagingItemsCache(items: [])
		pageViewController.removeAllViewControllers()
		collectionView.reloadData()
	}
}

// MARK: UICollectionViewDataSource

extension PagingViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return itemsCache.items.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let pagingMenuItem = itemsCache.item(for: indexPath)
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: type(of: pagingMenuItem)),
      for: indexPath) as! PagingMenuCell
    var isSelected = false
    if let currentItem = state.currentItem {
      isSelected = currentItem.isEqual(to: pagingMenuItem)
    }
    cell.setItem(pagingMenuItem, selected: isSelected, options: options)
    return cell
  }
}

// MARK: UICollectionViewDelegate

extension PagingViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = itemsCache.item(for: indexPath)
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
  }
}

// MARK: PageViewControllerDataSource

extension PagingViewController: PageViewControllerDataSource {
  public func pageViewController(_ pageViewController: PageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let dataSource = infiniteDataSource,
					let currentPagingMenuItem = state.currentItem,
					let item = dataSource.pagingViewController(self, itemBefore: currentPagingMenuItem) else {
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
		delegate?.pagingViewController(self, isScrollingFrom: startViewController, to: destinationViewController)
	}
	
  public func pageViewController(
    _ pageViewController: PageViewController,
    isScrollingFrom startViewController: UIViewController,
    to destinationViewController: UIViewController,
    with progress: CGFloat
  ) {
    switch state {
    case let .selected(currentSelectedItem):
      var toItem: PagingItem?
      if progress > 0 {
        toItem = item(after: currentSelectedItem)
      } else if progress < 0 {
        toItem = item(before: currentSelectedItem)
      } else {
        return
      }
      
      updateScrollingState(
        with: currentSelectedItem,
        toItem: toItem,
        initialContentOffset: .zero,
        distance: 0,
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
          with: fromItem,
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
		to destinationViewController: UIViewController
	) {
		guard case let .scrolling(fromItem, toItem, _, _, _) = state else {
			return
		}
		
		if let toItem = toItem {
			state = .selected(item: toItem)
		} else {
			state = .selected(item: fromItem)
		}
		
		delegate?.pagingViewController(self, didEndScrollFrom: startViewController, to: destinationViewController)
	}
}
