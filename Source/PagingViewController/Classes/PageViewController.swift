//
//  PageViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public final class PageViewController: UIViewController {
  
  // MARK: Public Props
	
	public private(set) var options: PagingOptions
  
  public weak var dataSource: PageViewControllerDataSource?
  public weak var delegate: PageViewControllerDelegate?
  
  public private(set) var selectedViewController: UIViewController?
  
  public private(set) var previousViewController: UIViewController?
  
  public private(set) var nextViewController: UIViewController?
  
  public var state: PageState {
    if previousViewController == nil, nextViewController == nil, selectedViewController == nil {
      return .empty
		} else if previousViewController == nil, nextViewController == nil {
			return .single
		} else if previousViewController == nil {
      return .first
    } else if nextViewController == nil {
      return .last
    } else {
      return .centered
    }
  }
  
  public private(set) lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isPagingEnabled = true
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.translatesAutoresizingMaskIntoConstraints = true
//    scrollView.showsHorizontalScrollIndicator = false
//    scrollView.showsVerticalScrollIndicator = false
    scrollView.autoresizingMask = [
      .flexibleTopMargin,
      .flexibleRightMargin,
      .flexibleBottomMargin,
      .flexibleLeftMargin,
    ]
    scrollView.bounces = true
    return scrollView
  }()
	
	public var pageSize: CGFloat {
		return scrollView.bounds.width
	}
	
	// MARK: Private Props
  
  private var direction: PagingDirection = .none
  private var directionRestored: Bool = false
  
  private var transitionSource: PagingTransitionSource = .page
  
  private var contentSize: CGSize {
    return CGSize(
      width: view.bounds.width * CGFloat(state.proposedPageCount),
      height: view.bounds.height
    )
  }
	
	private var contentOffset: CGFloat {
		set {
      scrollView.contentOffset = CGPoint(x: newValue, y: 0)
    }
    get {
      return scrollView.contentOffset.x
    }
	}
  
  private var appearanceState: PageAppearanceState = .didDisappear
	
	public required init(options: PagingOptions) {
		self.options = options
		super.init(nibName: nil, bundle: nil)
	}
	
	public required init?(coder: NSCoder) {
		options = PagingOptions()
		super.init(coder: coder)
	}
  
  public override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(scrollView)
		scrollView.delegate = self
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		scrollView.frame = view.bounds
    layoutPages()
	}
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    appearanceState = .willAppear(animated: animated)
    if let selectedViewController = selectedViewController {
      beginAppearanceTransition(for: selectedViewController, isAppearing: true, animated: animated)
    }
    
    switch state {
    case .single, .first, .centered, .last:
      layoutPages()
    default:
      break
    }
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    appearanceState = .didDisappear
    if let selectedViewController = selectedViewController {
      endAppearanceTransition(for: selectedViewController)
    }
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    appearanceState = .willDisappear(animated: animated)
    if let selectedViewController = selectedViewController {
      beginAppearanceTransition(for: selectedViewController, isAppearing: false, animated: animated)
    }
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    appearanceState = .didDisappear
    if let selectedViewController = selectedViewController {
      endAppearanceTransition(for: selectedViewController)
    }
  }
  
  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate { _ in
//      self.layoutPages()
    }
  }
}

// MARK: Public Functions

public extension PageViewController {
  func selectViewController(_ viewController: UIViewController, direction: PagingDirection, animated: Bool) {
    transitionSource = .menu
    
    if state == .empty || !animated {
      selectViewController(viewController, animated: animated)
      return
    }
    
    resetState()
		
    switch direction {
    case .forward, .none:
      if let nextViewController = nextViewController {
        removeSubpage(nextViewController)
      }
      addSubpage(viewController)
      nextViewController = viewController
    case .reverse:
      if let previousViewController = previousViewController {
        removeSubpage(previousViewController)
      }
      addSubpage(viewController)
      previousViewController = viewController
    }
    
    layoutPages()
    
    scrollTowards(direction: direction, animated: animated)
  }
	
	func removeAllViewControllers() {
		let oldSelectedViewController = selectedViewController
		
		if let selectedViewController = selectedViewController {
      beginAppearanceTransition(for: selectedViewController, isAppearing: false, animated: false)
      removeSubpage(selectedViewController)
		}
		
		if let previousViewController = previousViewController {
      removeSubpage(previousViewController)
		}
		
		if let nextViewController = nextViewController {
      removeSubpage(nextViewController)
		}
		
		previousViewController = nil
		selectedViewController = nil
		nextViewController = nil
		
    layoutPages()
		
		if let oldSelectedViewController = oldSelectedViewController {
      endAppearanceTransition(for: oldSelectedViewController)
		}
	}
}

// MARK: Private Functions

private extension PageViewController {
  func addSubpage(_ viewController: UIViewController) {
    viewController.willMove(toParent: self)
    addChild(viewController)
    scrollView.addSubview(viewController.view)
    viewController.didMove(toParent: self)
  }
  
  func removeSubpage(_ viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
    viewController.didMove(toParent: nil)
  }
  
  func layoutPages() {
    var viewControllers: [UIViewController] = []
    
    if let previousViewController = previousViewController {
      viewControllers.append(previousViewController)
    }
    if let selectedViewController = selectedViewController {
      viewControllers.append(selectedViewController)
    }
    if let nextViewController = nextViewController {
      viewControllers.append(nextViewController)
    }
    
    view.layoutIfNeeded()
    
    for (index, viewController) in viewControllers.enumerated() {
      viewController.view.frame = CGRect(
        origin: CGPoint(
          x: CGFloat(index) * pageSize,
          y: 0
        ),
        size: scrollView.bounds.size
      )
    }
    
    scrollView.contentSize = contentSize
    
    var diff: CGFloat = 0
    if contentOffset > pageSize * 2 {
      diff = contentOffset - pageSize * 2
    } else if pageSize < contentOffset, contentOffset < pageSize * 2 {
      diff = contentOffset - pageSize
    } else if contentOffset < pageSize, contentOffset < 0 {
      diff = pageSize
    }
    
    switch state {
    case .empty, .single, .first:
      contentOffset = diff
    case .centered, .last:
      contentOffset = diff + pageSize
    }
  }
  
  func willBeginScrollTowards(direction: PagingDirection) {
    switch direction {
    case .forward:
      if let fromViewController = selectedViewController,
         let toViewController = nextViewController {
        beginAppearanceTransition(for: fromViewController, isAppearing: false, animated: true)
        beginAppearanceTransition(for: toViewController, isAppearing: true, animated: true)
        delegate?.pageViewController(
          self,
          willBeginScrollFrom: fromViewController,
          to: toViewController
        )
      }
    case .reverse:
      if let fromViewController = selectedViewController,
         let toViewController = previousViewController {
        beginAppearanceTransition(for: fromViewController, isAppearing: false, animated: true)
        beginAppearanceTransition(for: toViewController, isAppearing: true, animated: true)
        delegate?.pageViewController(
          self,
          willBeginScrollFrom: fromViewController,
          to: toViewController
        )
      }
    case .none:
      break
    }
  }
  
  func scrollTowards(direction: PagingDirection, animated: Bool) {
    switch direction {
    case .forward, .none:
      switch state {
      case .first:
        scrollView.setContentOffset(CGPoint(x: pageSize, y: 0), animated: animated)
      case .centered:
        scrollView.setContentOffset(CGPoint(x: pageSize * 2, y: 0), animated: animated)
      default:
        break
      }
    case .reverse:
      switch state {
      case .last, .centered:
        scrollView.setContentOffset(.zero, animated: animated)
      default:
        break
      }
    }
  }
  
  func didEndScrollTowards(direction: PagingDirection) {
    switch direction {
    case .forward:
      guard let oldSelectedViewController = selectedViewController,
            let oldNextViewController = nextViewController else {
        return
      }
      
      delegate?.pageViewController(
        self,
        didEndScrollFrom: oldSelectedViewController,
        to: oldNextViewController,
        transitionSuccessful: true
      )
      
      let newNextViewController = dataSource?.pageViewController(self, viewControllerAfter: oldNextViewController)
      
      if let oldPreviousViewController = previousViewController,
         oldPreviousViewController !== newNextViewController {
        removeSubpage(oldPreviousViewController)
      }
      
      if let newNextViewController = newNextViewController,
         newNextViewController !== previousViewController {
        addSubpage(newNextViewController)
      }
      
      switch transitionSource {
      case .menu:
        let newPreviousViewController = dataSource?.pageViewController(self, viewControllerBefore: oldNextViewController)
        if let oldSelectedViewController = selectedViewController {
          removeSubpage(oldSelectedViewController)
        }
        if let newPreviousViewController = newPreviousViewController {
          addSubpage(newPreviousViewController)
        }
        previousViewController = newPreviousViewController
      case .page:
        previousViewController = oldSelectedViewController
      }
      
      selectedViewController = oldNextViewController
      nextViewController = newNextViewController
      
      layoutPages()
      
      endAppearanceTransition(for: oldSelectedViewController)
      endAppearanceTransition(for: oldNextViewController)
    case .reverse:
      guard let oldPreviousViewController = previousViewController,
            let oldSelectedViewController = selectedViewController else {
        return
      }
      
      delegate?.pageViewController(
        self,
        didEndScrollFrom: oldSelectedViewController,
        to: oldPreviousViewController,
        transitionSuccessful: true
      )
      
      let newPreviousViewController = dataSource?.pageViewController(self, viewControllerBefore: oldPreviousViewController)
      
      if let oldNextViewController = nextViewController,
         oldNextViewController !== newPreviousViewController {
        removeSubpage(oldNextViewController)
      }
      
      if let newPreviousViewController = newPreviousViewController,
         newPreviousViewController !== nextViewController {
        addSubpage(newPreviousViewController)
      }
      
      switch transitionSource {
      case .menu:
        let newNextViewController = dataSource?.pageViewController(self, viewControllerAfter: oldPreviousViewController)
        if let oldSelectedViewController = selectedViewController {
          removeSubpage(oldSelectedViewController)
        }
        if let newNextViewController = newNextViewController {
          addSubpage(newNextViewController)
        }
        nextViewController = newNextViewController
      case .page:
        nextViewController = oldSelectedViewController
      }

      previousViewController = newPreviousViewController
      selectedViewController = oldPreviousViewController
      
      layoutPages()
      
      endAppearanceTransition(for: oldSelectedViewController)
      endAppearanceTransition(for: oldPreviousViewController)
    case .none:
      break
    }
  }
  
  func onPageScroll(with progress: CGFloat) {
//    print("🟢 ", direction)
    switch direction {
    case .forward:
      if let fromViewController = selectedViewController,
         let toViewController = nextViewController {
        delegate?.pageViewController(
          self,
          isScrollingFrom: fromViewController,
          to: toViewController,
          with: progress
        )
      }
    case .reverse:
      if let fromViewController = selectedViewController,
         let toViewController = previousViewController {
        delegate?.pageViewController(
          self,
          isScrollingFrom: fromViewController,
          to: toViewController,
          with: progress
        )
      }
    case .none:
      break
    }
  }
  
  func cancelScrollTowards(direction: PagingDirection) {
    guard let selectedViewController = selectedViewController else {
      return
    }
    
    switch direction {
    case .forward:
      let oldNextViewController = nextViewController
      if let oldNextViewController = oldNextViewController {
        beginAppearanceTransition(for: selectedViewController, isAppearing: true, animated: true)
        beginAppearanceTransition(for: oldNextViewController, isAppearing: false, animated: true)
      }
      
      if let oldNextViewController = oldNextViewController {
        endAppearanceTransition(for: selectedViewController)
        endAppearanceTransition(for: oldNextViewController)
        delegate?.pageViewController(
          self,
          didEndScrollFrom: selectedViewController,
          to: oldNextViewController,
          transitionSuccessful: false
        )
      }
    case .reverse:
      let oldPreviousViewController = previousViewController
      if let oldPreviousViewController = oldPreviousViewController {
        beginAppearanceTransition(for: selectedViewController, isAppearing: true, animated: true)
        beginAppearanceTransition(for: oldPreviousViewController, isAppearing: false, animated: true)
      }
      
      if let oldPreviousViewController = oldPreviousViewController {
        endAppearanceTransition(for: selectedViewController)
        endAppearanceTransition(for: oldPreviousViewController)
        delegate?.pageViewController(
          self,
          didEndScrollFrom: selectedViewController,
          to: oldPreviousViewController,
          transitionSuccessful: false
        )
      }
    default:
      break
    }
  }
  
  func selectViewController(_ viewController: UIViewController, animated: Bool) {
    let newPreviousViewController = dataSource?.pageViewController(self, viewControllerBefore: viewController)
    let newNextViewController = dataSource?.pageViewController(self, viewControllerAfter: viewController)
    
    let oldSelectedViewController = selectedViewController
    
    if let oldSelectedViewController = oldSelectedViewController {
      beginAppearanceTransition(for: oldSelectedViewController, isAppearing: false, animated: animated)
    }
    
    if viewController !== selectedViewController {
      beginAppearanceTransition(for: viewController, isAppearing: true, animated: animated)
    }
    
    let oldViewControllers = [
      previousViewController,
      selectedViewController,
      nextViewController
    ]
      .filter {
        $0 != nil
      }
    
    let newViewControllers = [
      newPreviousViewController,
      viewController,
      newNextViewController
    ]
      .filter {
        $0 != nil
      }
    
    oldViewControllers
      .filter { !newViewControllers.contains($0) }
      .forEach {
        removeSubpage($0!)
      }
    
    newViewControllers
      .filter { !oldViewControllers.contains($0) }
      .forEach {
        addSubpage($0!)
      }
    
    previousViewController = newPreviousViewController
    selectedViewController = viewController
    nextViewController = newNextViewController

    layoutPages()
    
    if let oldSelectedViewController = oldSelectedViewController {
      endAppearanceTransition(for: oldSelectedViewController)
    }
    
    if viewController !== oldSelectedViewController {
      endAppearanceTransition(for: viewController)
    }
  }
  
  func beginAppearanceTransition(
    for viewController: UIViewController,
    isAppearing: Bool,
    animated: Bool
  ) {
    switch appearanceState {
    case let .willAppear(animated):
      viewController.beginAppearanceTransition(isAppearing, animated: animated)
    case .didAppear:
      viewController.beginAppearanceTransition(isAppearing, animated: animated)
    case let .willDisappear(animated):
      viewController.beginAppearanceTransition(false, animated: animated)
    default:
      break
    }
  }
  
  func endAppearanceTransition(for viewController: UIViewController) {
    guard case .didAppear = appearanceState else {
      return
    }
    
    viewController.endAppearanceTransition()
  }
	
	func resetState() {
		defer {
      directionRestored = false
		}
		
		if directionRestored {
			direction = .none
		}
	}
}

// MARK: UIScrollViewDelegate

extension PageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let distance = pageSize
    var progress: CGFloat
    
    switch state {
    case .empty, .single, .first:
      progress = contentOffset / distance
    case .last, .centered:
      progress = (contentOffset - distance) / distance
    }
    
    let currentDirection = PagingDirection(progress: progress)
    
    switch direction {
    case .forward, .reverse:
      if transitionSource == .menu {
        switch (direction, currentDirection) {
        case (.forward, .reverse),
          (.reverse, .forward):
          cancelScrollTowards(direction: direction)
          direction = currentDirection
          willBeginScrollTowards(direction: currentDirection)
        default:
          break
        }
      }
    case .none:
      direction = currentDirection
      willBeginScrollTowards(direction: direction)
    }
    
    onPageScroll(with: progress)
    
    if !directionRestored {
      if progress >= 1 || progress <= -1 {
        directionRestored = true
        didEndScrollTowards(direction: direction)
      } else if progress == 0 {
        print("❌")
        switch direction {
        case .forward, .reverse:
          directionRestored = true
          cancelScrollTowards(direction: direction)
        default:
          break
        }
      }
    }
	}
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    resetState()

    transitionSource = .page
  }
  
  public func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    resetState()
  }
}
