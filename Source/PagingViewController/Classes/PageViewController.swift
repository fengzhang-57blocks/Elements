//
//  PageViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public final class PageViewController: UIViewController {
	
	public private(set) var options: PagingOptions
  
  public weak var delegate: PageViewControllerDelegate?
  public weak var dataSource: PageViewControllerDataSource?
  
  public private(set) var selectedViewController: UIViewController?
  
  public private(set) var previousViewController: UIViewController?
  
  public private(set) var nextViewController: UIViewController?
  
  public var state: PageViewState {
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
  
	private var direction: PageViewDirection = .none
	
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
  func selectViewController(_ viewController: UIViewController, direction: PageViewDirection, animated: Bool) {
//    if let selectedViewController = selectedViewController,
//       viewController.isEqual(selectedViewController) {
//      return
//    }
    
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
    
    scrollTowardsTo(direction: direction, animated: animated)
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
	
	func scrollTowardsTo(direction: PageViewDirection, animated: Bool) {
		switch direction {
		case .forward, .none:
			switch state {
			case .first:
				scrollView.setContentOffset(CGPoint(x: pageSize, y: 0), animated: true)
			case .centered:
				scrollView.setContentOffset(CGPoint(x: pageSize * 2, y: 0), animated: true)
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
	
	func willBeginScrollTowardsTo(direction: PageViewDirection) {
		switch direction {
		case .forward:
			if let nextViewController = nextViewController,
				 let selectedViewController = selectedViewController {
				delegate?.pageViewController(self, willBeginScrollFrom: selectedViewController, to: nextViewController)
			}
		case .reverse:
			if let previousViewController = previousViewController,
				 let selectedViewController = selectedViewController {
				delegate?.pageViewController(self, willBeginScrollFrom: selectedViewController, to: previousViewController)
			}
		case .none:
			break
		}
	}
	
	func didEndScrollTowardsTo(direction: PageViewDirection) {
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
	
	func sendScrollToDelegate(with progress: CGFloat) {
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
		case .reverse:
			if let previousViewController = previousViewController, let selectedViewController = selectedViewController {
				delegate?.pageViewController(
					self,
					isScrollingFrom: selectedViewController,
					to: previousViewController,
					with: progress
				)
			}
		case .none:
			break
		}
	}
	
	func selectViewController(_ viewController: UIViewController, animated: Bool) {
    let oldSelectedViewController = selectedViewController
    let newPreviousViewController = dataSource?.pageViewController(self, viewControllerBefore: viewController)
    let newNextViewController = dataSource?.pageViewController(self, viewControllerAfter: viewController)

    if let oldPreviosViewController = previousViewController {
      if oldPreviosViewController !== viewController,
        oldPreviosViewController !== newPreviousViewController,
        oldPreviosViewController !== newNextViewController {
        removeViewController(oldPreviosViewController)
      }
    }

    if let oldSelectedViewController = selectedViewController {
      if oldSelectedViewController !== newPreviousViewController,
        oldSelectedViewController !== newNextViewController {
        removeViewController(oldSelectedViewController)
      }
    }

    if let oldNextViewController = nextViewController {
      if oldNextViewController !== viewController,
        oldNextViewController !== newPreviousViewController,
        oldNextViewController !== newNextViewController {
        removeViewController(oldNextViewController)
      }
    }

    if let newPreviousViewController = newPreviousViewController {
      if newPreviousViewController !== selectedViewController,
        newPreviousViewController !== previousViewController,
        newPreviousViewController !== nextViewController {
        addViewController(newPreviousViewController)
      }
    }

    if viewController !== nextViewController,
       viewController !== previousViewController {
      addViewController(viewController)
    }

    if let newNextViewController = newNextViewController {
      if newNextViewController !== selectedViewController,
          newNextViewController !== previousViewController,
          newNextViewController !== nextViewController {
          addViewController(newNextViewController)
      }
    }

    previousViewController = newPreviousViewController
    selectedViewController = viewController
    nextViewController = newNextViewController

    layoutViewControllers()
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
    
    let scrollDirection = PageViewDirection(progress: progress)
		
		switch direction {
		case .none:
			direction = scrollDirection
			sendScrollToDelegate(with: progress)
			willBeginScrollTowardsTo(direction: direction)
		case .forward, .reverse:
			sendScrollToDelegate(with: progress)
		}
		
		if progress >= 1 || progress <= -1 {
			didEndScrollTowardsTo(direction: scrollDirection)
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
