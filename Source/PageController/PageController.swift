//
//  PageController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public class PageController: UIViewController {
	
	public lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.delegate = self
		scrollView.isPagingEnabled = true
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	
	
	weak public var dataSource: PageControllerDataSource?
	weak public var delegate: PageControllerDelegate?
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(scrollView)
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		
	}
}

extension PageController: UIScrollViewDelegate {
	
}
