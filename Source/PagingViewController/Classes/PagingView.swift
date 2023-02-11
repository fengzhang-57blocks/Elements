//
//  PagingView.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

open class PagingView: UIView {
	
	public let collectionView: UICollectionView
	public let pageView: UIView
	
	public var options: PagingMenuOptions
  
  private var heightConstraint: NSLayoutConstraint?
	
	public required init(collectionView: UICollectionView, pageView: UIView, options: PagingMenuOptions) {
		self.collectionView = collectionView
		self.pageView = pageView
		self.options = options
		super.init(frame: .zero)
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func createLayout() {
    addSubview(pageView)
		addSubview(collectionView)
		setupConstraints()
	}
	
	open func setupConstraints() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		pageView.translatesAutoresizingMaskIntoConstraints = false

    let metrics = [
      "height": options.menuItemSize.height
    ]
    let views = [
      "collectionView": collectionView,
      "pageView": pageView,
    ]
    
    let formatOptions = NSLayoutConstraint.FormatOptions()
    
    addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[collectionView]|",
        options: formatOptions,
        metrics: metrics,
        views: views
      )
    )
    addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[pageView]|",
        options: formatOptions,
        metrics: metrics,
        views: views
      )
    )
		
    var verticalVisualFormat: String
		switch options.position {
		case .top:
      verticalVisualFormat = "V:|[collectionView(==height)][pageView]|"
		case .bottom:
      verticalVisualFormat = "V:|[pageView][collectionView(==height)]|"
		}
    
    let verticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: verticalVisualFormat,
      options: formatOptions,
      metrics: metrics,
      views: views
    )
    
    addConstraints(verticalConstraints)
    
    for constraint in verticalConstraints {
      if constraint.firstAttribute == .height {
        heightConstraint = constraint
      }
    }
	}
}
