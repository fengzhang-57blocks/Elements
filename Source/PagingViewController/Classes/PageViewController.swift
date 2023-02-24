//
//  PageViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit
import Foundation

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
	
	public var scrollDirection: PageScrollDirection {
		return options.pageScrollDirection
	}
	
	public var pageSize: CGFloat {
		switch scrollDirection {
		case .horizontal:
			return scrollView.bounds.width
		case .vertical:
			return scrollView.bounds.height
		}
	}
	
	// MARK: Private Props
  
  private var transitionDirection: PagingTransitionDirection = .none
	private var shouldRestoreTransitionDireciton: Bool = false
  
  private var transitionSource: PagingTransitionSource = .page
  
  private var contentSize: CGSize {
		switch scrollDirection {
		case .horizontal:
			return CGSize(
				width: view.bounds.width * CGFloat(state.proposedPageCount),
				height: view.bounds.height
			)
		case .vertical:
			return CGSize(
				width: view.bounds.width,
				height: view.bounds.height * CGFloat(state.proposedPageCount)
			)
		}
  }
	
	private var contentOffset: CGFloat {
		set {
			scrollView.contentOffset = point(from: newValue)
    }
    get {
			switch scrollDirection {
			case .horizontal:
				return scrollView.contentOffset.x
			case .vertical:
				return scrollView.contentOffset.y
			}
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
      beginAppearanceTransition(
        for: selectedViewController,
        isAppearing: true,
        animated: animated
      )
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
      beginAppearanceTransition(
        for: selectedViewController,
        isAppearing: false,
        animated: animated
      )
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
      self.layoutPages()
    }
  }
}

// MARK: Public Functions

public extension PageViewController {
  func selectViewController(_ viewController: UIViewController, direction: PagingTransitionDirection, animated: Bool) {
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
	
	func removeAllPages() {
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
  
  func viewController(before viewController: UIViewController) -> UIViewController? {
    return dataSource?.pageViewController(self, viewControllerBefore: viewController)
  }
  
  func viewController(after viewController: UIViewController) -> UIViewController? {
    return dataSource?.pageViewController(self, viewControllerAfter: viewController)
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
				origin: point(from: CGFloat(index) * pageSize),
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
	
	func setContentOffset(_ value: CGFloat, animated: Bool) {
		scrollView.setContentOffset(point(from: value), animated: animated)
	}
  
  func willBeginScrollTowards(direction: PagingTransitionDirection) {
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
  
  func scrollTowards(direction: PagingTransitionDirection, animated: Bool) {
    switch direction {
    case .forward, .none:
      switch state {
      case .first:
        setContentOffset(pageSize, animated: animated)
      case .centered:
				setContentOffset(pageSize * 2, animated: animated)
      default:
        break
      }
    case .reverse:
      switch state {
      case .last, .centered:
				setContentOffset(.zero, animated: animated)
      default:
        break
      }
    }
  }
  
  func didEndScrollTowards(direction: PagingTransitionDirection) {
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
      
      let newNextViewController = viewController(after: oldNextViewController)
      
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
        let newPreviousViewController = viewController(before: oldNextViewController)
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
      
      let newPreviousViewController = viewController(before: oldPreviousViewController)
      
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
        let newNextViewController = viewController(after: oldPreviousViewController)
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
    switch transitionDirection {
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
  
  func cancelScrollTowards(direction: PagingTransitionDirection) {
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
    let newPreviousViewController = self.viewController(before: viewController)
    let newNextViewController = self.viewController(after: viewController)
    
    let oldSelectedViewController = selectedViewController
    
    if let oldSelectedViewController = oldSelectedViewController {
      beginAppearanceTransition(
        for: oldSelectedViewController,
        isAppearing: false,
        animated: animated
      )
    }
    
    if viewController !== selectedViewController {
      beginAppearanceTransition(for: viewController, isAppearing: true, animated: animated)
    }
    
    let oldViewControllers = [previousViewController, selectedViewController, nextViewController]
      .filter {
        $0 != nil
      }
    
    let newViewControllers = [newPreviousViewController, viewController, newNextViewController]
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
	
	func point(from value: CGFloat) -> CGPoint {
		switch scrollDirection {
		case .horizontal:
			return CGPoint(x: value, y: 0)
		case .vertical:
			return CGPoint(x: 0, y: value)
		}
	}
	
	func resetState() {
		defer {
			shouldRestoreTransitionDireciton = false
		}
		
		if shouldRestoreTransitionDireciton {
			transitionDirection = .none
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
    
    let currentDirection = PagingTransitionDirection(progress: progress)
    
    switch transitionDirection {
    case .forward, .reverse:
      if transitionSource == .menu {
        switch (transitionDirection, currentDirection) {
        case (.forward, .reverse),
          (.reverse, .forward):
          cancelScrollTowards(direction: transitionDirection)
					transitionDirection = currentDirection
          willBeginScrollTowards(direction: currentDirection)
        default:
          break
        }
      }
    case .none:
			transitionDirection = currentDirection
      willBeginScrollTowards(direction: transitionDirection)
    }
    
    onPageScroll(with: progress)
    
    if !shouldRestoreTransitionDireciton {
      if progress >= 1 || progress <= -1 {
				shouldRestoreTransitionDireciton = true
        didEndScrollTowards(direction: transitionDirection)
      } else if progress == 0 {
        print("❌")
        switch transitionDirection {
        case .forward, .reverse:
					shouldRestoreTransitionDireciton = true
          cancelScrollTowards(direction: transitionDirection)
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
