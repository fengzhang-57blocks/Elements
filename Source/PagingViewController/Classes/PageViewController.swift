//
//  PageViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public final class PageViewController: UIViewController {
	
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
	
	public var pageSize: CGFloat {
		return scrollView.bounds.width
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
    scrollView.contentInsetAdjustmentBehavior = .never
		scrollView.translatesAutoresizingMaskIntoConstraints = true
//    scrollView.showsHorizontalScrollIndicator = false
//    scrollView.showsVerticalScrollIndicator = false
		scrollView.bounces = true
		return scrollView
	}()
  
  private var contentSize: CGSize {
    return CGSize(
      width: view.bounds.width * CGFloat(state.proposedPageCount),
      height: view.bounds.height
    )
  }
	
	private var contentOffset: CGFloat {
		set { scrollView.contentOffset = CGPoint(x: newValue, y: 0) }
		get { return scrollView.contentOffset.x }
	}
  
	private var direction: PagingDirection = .none
	
	public required init(options: PagingOptions) {
		self.options = options
		super.init(nibName: nil, bundle: nil)
	}
	
	public required init?(coder: NSCoder) {
		options = PagingOptions()
		super.init(coder: coder)
	}
  
  public override func loadView() {
    view = scrollView
  }
	
  public override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self
	}
}

// MARK: Public Functions

public extension PageViewController {
  func selectViewController(_ viewController: UIViewController, direction: PagingDirection, animated: Bool) {
    if state == .empty || !animated {
      selectViewController(viewController, animated: animated)
      return
    }
    
    resetState()
		
    switch direction {
    case .forward, .none:
      if let nextViewController = nextViewController {
        removeViewController(nextViewController)
      }
      addViewController(viewController)
      nextViewController = viewController
      layoutViewControllers()
    case .reverse:
      if let previousViewController = previousViewController {
        removeViewController(previousViewController)
      }
      addViewController(viewController)
      previousViewController = viewController
      layoutViewControllers()
    }
    
    scrollTowards(direction: direction, animated: animated)
  }
	
	func removeAllViewControllers() {
		for viewController in [
			previousViewController,
			selectedViewController,
			nextViewController,
		] {
			if let vc = viewController {
				removeViewController(vc)
			}
		}
		
		previousViewController = nil
		selectedViewController = nil
		nextViewController = nil
		
		layoutViewControllers()
	}
}

// MARK: Private Functions

private extension PageViewController {
  func selectViewController(_ viewController: UIViewController, animated: Bool) {
    let newPreviousViewController = dataSource?.pageViewController(self, viewControllerBefore: viewController)
    let newNextViewController = dataSource?.pageViewController(self, viewControllerAfter: viewController)
    
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
        removeViewController($0!)
      }
    
    newViewControllers
      .filter { !oldViewControllers.contains($0) }
      .forEach {
        addViewController($0!)
      }
    
    previousViewController = newPreviousViewController
    selectedViewController = viewController
    nextViewController = newNextViewController

    layoutViewControllers()
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
	
	func willBeginScrollTowards(direction: PagingDirection) {
		switch direction {
		case .forward:
			if let fromViewController = selectedViewController,
         let toViewController = nextViewController {
				delegate?.pageViewController(self, willBeginScrollFrom: fromViewController, to: toViewController)
			}
		case .reverse:
			if let fromViewController = selectedViewController,
         let toViewController = previousViewController {
				delegate?.pageViewController(self, willBeginScrollFrom: fromViewController, to: toViewController)
			}
		case .none:
			break
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
				to: oldNextViewController
			)
			
			let newNextViewController = dataSource?.pageViewController(self, viewControllerAfter: oldNextViewController)
			
			if let newNextViewController = newNextViewController,
         newNextViewController != previousViewController {
				addViewController(newNextViewController)
				if let oldPreviousViewController = previousViewController {
					removeViewController(oldPreviousViewController)
				}
			}
			
			previousViewController = oldSelectedViewController
			selectedViewController = oldNextViewController
			nextViewController = newNextViewController
			
			layoutViewControllers()
		case .reverse:
			guard let oldPreviousViewController = previousViewController,
					let oldSelectedViewController = selectedViewController else {
				return
			}
			
			delegate?.pageViewController(
				self,
				didEndScrollFrom: oldSelectedViewController,
				to: oldPreviousViewController
			)
			
			let newPreviousViewController = dataSource?.pageViewController(self, viewControllerBefore: oldPreviousViewController)
			
			if let newPreviousViewController = newPreviousViewController,
					newPreviousViewController != nextViewController {
				addViewController(newPreviousViewController)
				if let oldNextViewController = nextViewController {
					removeViewController(oldNextViewController)
				}
			}

			previousViewController = newPreviousViewController
			selectedViewController = oldPreviousViewController
			nextViewController = oldSelectedViewController
			
			layoutViewControllers()
		case .none:
			break
		}
	}
	
	func sendScrollingToDelegate(with progress: CGFloat) {
		switch direction {
		case .forward:
			if let fromViewController = selectedViewController, let toViewController = nextViewController {
				delegate?.pageViewController(
					self,
					isScrollingFrom: fromViewController,
					to: toViewController,
					with: progress
				)
			}
		case .reverse:
			if let fromViewController = selectedViewController, let toViewController = previousViewController {
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
	
	func resetState() {
		direction = .none
	}
}

// MARK: UIScrollViewDelegate

extension PageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let distance = view.bounds.width
    var progress: CGFloat
    
    switch state {
    case .empty, .single, .first:
      progress = contentOffset / distance
    case .last, .centered:
      progress = (contentOffset - distance) / distance
    }
    
    let scrollDirection = PagingDirection(progress: progress)
		
		switch direction {
		case .none:
			direction = scrollDirection
      sendScrollingToDelegate(with: progress)
			willBeginScrollTowards(direction: direction)
		case .forward, .reverse:
      sendScrollingToDelegate(with: progress)
		}
		
		if progress >= 1 || progress <= -1 {
			didEndScrollTowards(direction: scrollDirection)
		} else if progress == 0 {
			
		}
	}
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    resetState()
  }
  
  public func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    resetState()
  }
}
