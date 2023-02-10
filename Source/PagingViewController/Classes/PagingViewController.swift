//
//  PagingViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

open class PagingViewController: UIViewController {
	
	public weak var dataSource: PagingViewControllerDataSource?
	public weak var delegate: PagingViewControllerDelegate?
	
	public private(set) var pageViewController: PageViewController
	
	public let collectionView: UICollectionView
	public private(set) var collectionViewLayout: PagingMenuCollectionViewLayout {
		didSet {
//			collectionViewLayout.itemsCache = 
		}
	}
	
	public private(set) var options: PagingMenuOptions
	
	public init(options: PagingMenuOptions) {
		self.options = options
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
		super.init(nibName: nil, bundle: nil)
		collectionView.delegate = self
	}
	
	public required init?(coder: NSCoder) {
		options = PagingMenuOptions()
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
		super.init(coder: coder)
		collectionView.delegate = self
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
		pageViewController.didMove(toParent: self)
		pagingView.createLayout()
		
		pageViewController.dataSource = self
		pageViewController.delegate = self
	}
}

extension PagingViewController: PageViewControllerDataSource {
	
}

extension PagingViewController: PageViewControllerDelegate {
	public func pageViewController(
		_ pageViewController: PageViewController,
		willBeginScroll fromViewController: UIViewController,
		to destinationViewController: UIViewController
	) {
		
	}
	
	public func pageViewController(
		_ pageViewController: PageViewController,
		isScrolling fromViewController: UIViewController,
		to destinationViewController: UIViewController,
		with progress: CGFloat
	) {
		
	}
	
	public func pageViewController(
		_ pageViewController: PageViewController,
		didEndScroll fromViewController: UIViewController,
		to destinationViewController: UIViewController
	) {
		
	}
}

extension PagingViewController: UIScrollViewDelegate {
	
}

extension PagingViewController: UICollectionViewDelegate {
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}
