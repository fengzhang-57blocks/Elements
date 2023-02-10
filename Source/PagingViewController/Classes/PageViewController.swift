//
//  PageViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

open class PageViewController: UIViewController {
	
	public private(set) var options: PagingMenuOptions
	
	public weak var dataSource: PageViewControllerDataSource?
	public weak var delegate: PageViewControllerDelegate?
	
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
		scrollView.bounces = true
		return scrollView
	}()
	
	public required init(options: PagingMenuOptions) {
		self.options = options
		super.init(nibName: nil, bundle: nil)
	}
	
	public required init?(coder: NSCoder) {
		options = PagingMenuOptions()
		super.init(coder: coder)
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(scrollView)
		scrollView.delegate = self
	}
	
}

public extension PageViewController {
	
}

private extension PageViewController {
	
}

extension PageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
	}
}
