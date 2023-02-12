//
//  PageViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

open class PageViewController: UIViewController {
	
	public private(set) var options: PagingMenuOptions
  
  public weak var delegate: PageViewControllerDelegate?
  public weak var dataSource: PageViewControllerDataSource?
  
  public private(set) var selectedViewController: UIViewController?
  
  public private(set) var previousViewController: UIViewController?
  
  public private(set) var nextViewController: UIViewController?
  
  public var position: PageViewPosition {
    if previousViewController == nil, nextViewController == nil, selectedViewController == nil {
      return .empty
    } else if previousViewController == nil, nextViewController == nil {
      return .single
    } else if nextViewController == nil {
      return .last
    } else if previousViewController == nil {
      return .first
    } else {
      return .centered
    }
  }
	
	public private(set) lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.autoresizingMask = [
			.flexibleTopMargin,
			.flexibleRightMargin,
			.flexibleBottomMargin,
			.flexibleLeftMargin,
		]
		scrollView.isPagingEnabled = true
		scrollView.translatesAutoresizingMaskIntoConstraints = true
//    scrollView.showsHorizontalScrollIndicator = false
//    scrollView.showsVerticalScrollIndicator = false
		scrollView.bounces = true
		return scrollView
	}()
  
  private var contentSize: CGSize {
    return CGSize(
      width: view.bounds.width * CGFloat(position.proposedPageCount),
      height: view.bounds.height
    )
  }
  
//  private var viewControllerCache: PageViewControllerCache
	
	public required init(options: PagingMenuOptions) {
		self.options = options
//    viewControllerCache = PageViewControllerCache(viewControllers: [])
		super.init(nibName: nil, bundle: nil)
	}
	
	public required init?(coder: NSCoder) {
		options = PagingMenuOptions()
//    viewControllerCache = PageViewControllerCache(viewControllers: [])
		super.init(coder: coder)
	}
  
  open override func loadView() {
    view = scrollView
  }
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self
    scrollView.contentInsetAdjustmentBehavior = .never
	}
}

// MARK: Public Functions

public extension PageViewController {
  func selectViewController(_ viewController: UIViewController, direction: PageViewDirection, animated: Bool) {
    if let selectedViewController = selectedViewController,
        viewController.isEqual(selectedViewController) {
      return
    }
    
    switch direction {
    case .forward, .none:
      if let nextViewController = nextViewController {
        removeViewController(nextViewController)
      }
      addViewController(viewController)
      nextViewController = viewController
      layoutViewControllers()
    case .backward:
      if let previousViewController = previousViewController {
        removeViewController(previousViewController)
      }
      addViewController(viewController)
      previousViewController = viewController
      layoutViewControllers()
    }
    
    scrollTowardsTo(direction: direction, animated: animated)
  }
  
  func scrollTowardsTo(direction: PageViewDirection, animated: Bool) {
    switch direction {
    case .forward, .none:
      switch position {
      case .first:
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: animated)
      case .centered:
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * 2, y: 0), animated: animated)
      default:
        break
      }
    case .backward:
      switch position {
      case .last, .centered:
        scrollView.setContentOffset(.zero, animated: animated)
      default:
        break
      }
    }
  }
}

// MARK: Private Functions

private extension PageViewController {
  func addViewController(_ viewController: UIViewController) {
    viewController.willMove(toParent: self)
    addChild(viewController)
    scrollView.addSubview(viewController.view)
    viewController.didMove(toParent: self)
  }
  
  func removeViewController(_ viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
    viewController.didMove(toParent: nil)
  }
  
  func layoutViewControllers() {
    var viewControllers: [UIViewController] = []
    
    if let previousViewController = previousViewController {
      viewControllers.append(previousViewController)
    }
    if let currentViewController = selectedViewController {
      viewControllers.append(currentViewController)
    }
    if let nextViewController = nextViewController {
      viewControllers.append(nextViewController)
    }
    
//    viewControllerCache = PageViewControllerCache(viewControllers: viewControllers)
    
    for (index, viewController) in viewControllers.enumerated() {
      viewController.view.frame = CGRect(
        origin: CGPoint(
          x: CGFloat(index) * scrollView.bounds.width,
          y: 0
        ),
        size: scrollView.bounds.size
      )
    }
    
    scrollView.contentSize = contentSize
  }
  
}

// MARK: UIScrollViewDelegate

extension PageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let distance = view.bounds.width
    var progress: CGFloat
    
    switch position {
    case .empty, .single, .first:
      progress = scrollView.contentOffset.x / distance
    case .last, .centered:
      progress = (scrollView.contentOffset.x - distance) / distance
    }
    
    let direction = PageViewDirection(progress: progress)
    
    switch direction {
    case .forward:
      if let selectedViewController = selectedViewController, let nextViewController = nextViewController {
        delegate?.pageViewController(
          self,
          isScrollingFrom: selectedViewController,
          to: nextViewController,
          with: progress
        )
      }
    case .backward:
      if let previousViewController = previousViewController, let selectedViewController = selectedViewController {
        delegate?.pageViewController(
          self,
          isScrollingFrom: selectedViewController,
          to: previousViewController,
          with: progress
        )
      }
    default:
      break
    }
	}
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
  }
  
  public func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    
  }
}
