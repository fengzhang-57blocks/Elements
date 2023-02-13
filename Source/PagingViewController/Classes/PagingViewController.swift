//
//  PagingViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

extension PagingViewController {
  enum DataSourceReference {
    case none
    case finite(PagingViewControllerFiniteDataSource)
    case `static`(PagingViewControllerStaticDataSource)
  }
}

open class PagingViewController: UIViewController {
  
  public private(set) var options: PagingMenuOptions
  public private(set) var state: PagingMenuState {
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
	
  public private(set) var itemCache: PagingMenuItemCache {
    didSet {
      collectionViewLayout.itemCache = itemCache
    }
  }
  
  private(set) var sizeCache: PagingMenuItemSizeCache {
    didSet {
      collectionViewLayout.sizeCahce = sizeCache
    }
  }
  
  private var didLayoutSubviews: Bool = false
  
  private var dataSourceReference: DataSourceReference = .none
	
	public init(options: PagingMenuOptions = PagingMenuOptions()) {
		self.options = options
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
    sizeCache = PagingMenuItemSizeCache(options: options)
    itemCache = PagingMenuItemCache(items: [])
    state = .empty
		super.init(nibName: nil, bundle: nil)
		collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.contentInsetAdjustmentBehavior = .never
    
    register(PagingMenuTitleCell.self, for: PagingMenuIndexItem.self)
	}
  
  public convenience init(
    options: PagingMenuOptions = PagingMenuOptions(),
    viewControllers: [UIViewController]
  ) {
    self.init(options: options)
    configureStaticDataSource()
  }
	
	public required init?(coder: NSCoder) {
		options = PagingMenuOptions()
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
    sizeCache = PagingMenuItemSizeCache(options: options)
    itemCache = PagingMenuItemCache(items: [])
    state = .empty
		super.init(coder: coder)
		collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.contentInsetAdjustmentBehavior = .never
    
    register(PagingMenuTitleCell.self, for: PagingMenuIndexItem.self)
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
        selectPageItem(item, animated: false)
        collectionView.selectItem(
          at: itemCache.indexPath(for: item),
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
  func register(_ cellClass: AnyClass?, for item: PagingMenuItem.Type) {
    collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: item))
  }
  
  func register(_ nib: UINib?, for item: PagingMenuItem.Type) {
    collectionView.register(nib, forCellWithReuseIdentifier: String(describing: item))
  }
  
  func selectItem(_ item: PagingMenuItem, animated: Bool) {
    if collectionView.superview == nil || collectionView.window == nil {
      state = .selected(item: item)
      return
    }

    switch state {
    case .empty:
      state = .selected(item: item)
      selectPageItem(item, animated: animated)
      collectionView.selectItem(
        at: itemCache.indexPath(for: item),
        animated: animated,
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
        selectPageItem(item, animated: animated)
      } else {
        state = .selected(item: item)
        selectPageItem(item, animated: animated)
        collectionView.selectItem(
          at: itemCache.indexPath(for: item),
          animated: animated,
          scrollPosition: .centeredHorizontally
        )
      }
    default:
      break
    }
    
    collectionView.reloadData()
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
    var items: [PagingMenuItem] = []
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
    
    if let prevSelectedItem = state.currentPagingMenuItem {
      if let currentSelectedItem = items.first(where: { $0.isEqual(to: prevSelectedItem) }) {
        state = .selected(item: currentSelectedItem)
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
  func configureFiniteDataSource() {
    let items = allPagingMenuItems()
    itemCache = PagingMenuItemCache(items: items)
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
    itemCache = PagingMenuItemCache(items: dataSource.items)
    dataSourceReference = .static(dataSource)
    infiniteDataSource = dataSource
    
    if let firstItem = dataSource.items.first {
      selectItem(firstItem, animated: false)
    }
  }
  
  func allPagingMenuItems() -> [PagingMenuItem] {
    guard let dataSource = dataSource else {
      return []
    }
    
    var items: [PagingMenuItem] = []
    for index in 0..<dataSource.numberOfViewControllers() {
      items.append(dataSource.pagingViewController(self, pagingMenuItemAt: index))
    }
    
    return items
  }
  
  func resetState() {
    state = .empty
    sizeCache.clearCahces()
    itemCache = PagingMenuItemCache(items: [])
    collectionView.reloadData()
  }
  
  func pagingMenuItemBefore(_ item: PagingMenuItem) -> PagingMenuItem? {
    return infiniteDataSource?.pagingViewController(self, itemBefore: item)
  }
  
  func pagingMenuItemAfter(_ item: PagingMenuItem) -> PagingMenuItem? {
    return infiniteDataSource?.pagingViewController(self, itemAfter: item)
  }
  
  func selectPageItem(_ item: PagingMenuItem, animated: Bool) {
    guard let dataSource = infiniteDataSource else {
      return
    }
    
    let viewController = dataSource.pagingViewController(self, viewControllerFor: item)
    pageViewController.selectViewController(
      viewController,
      direction: .none,
      animated: animated
    )
  }
  
  func updateScrollingState(
    with fromItem: PagingMenuItem,
    toItem: PagingMenuItem?,
    initialContentOffset: CGPoint,
    distance: CGFloat,
    progress: CGFloat
  ) {
		print(progress)
    state = .scrolling(
      fromItem: fromItem,
      toItem: toItem,
      initialContentOffset: initialContentOffset,
      distance: distance,
      progress: progress
    )
    
    if .scrollAlongside == options.menuTransitionBehaviour {
      let invalidatingContext = PagingMenuCollectionViewLayoutInvalidationContext()
      if let _ = toItem, sizeCache.implementedSizeDelegate {
        invalidatingContext.invalidateSize = true
      }
      collectionViewLayout.invalidateLayout(with: invalidatingContext)
    }
  }
}

// MARK: UICollectionViewDataSource

extension PagingViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return itemCache.items.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let pagingMenuItem = itemCache.item(for: indexPath)
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: type(of: pagingMenuItem)),
      for: indexPath) as! PagingMenuCell
    var isSelected = false
    if let currentItem = state.currentPagingMenuItem {
      isSelected = currentItem.isEqual(to: pagingMenuItem)
    }
    cell.setPagingMenuItem(pagingMenuItem, selected: isSelected, options: options)
    return cell
  }
}

// MARK: UICollectionViewDelegate

extension PagingViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = itemCache.item(for: indexPath)
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
        let currentPagingMenuItem = state.currentPagingMenuItem,
          let item = dataSource.pagingViewController(self, itemBefore: currentPagingMenuItem) else {
      return nil
    }
    
    return dataSource.pagingViewController(self, viewControllerFor: item)
  }
  
  public func pageViewController(_ pageViewController: PageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let dataSource = infiniteDataSource,
        let currentPagingMenuItem = state.currentPagingMenuItem,
          let item = dataSource.pagingViewController(self, itemAfter: currentPagingMenuItem) else {
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
      var toItem: PagingMenuItem?
      if progress > 0 {
        toItem = pagingMenuItemAfter(currentSelectedItem)
      } else if progress < 0 {
        toItem = pagingMenuItemBefore(currentSelectedItem)
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
		print("finish")
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
