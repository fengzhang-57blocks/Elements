//
//  PagingMenu.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class PagingMenu: UIView {

	public var layout: PagingOptions = PagingOptions() {
		didSet {
			collectionView.reloadData()
		}
	}

	public private(set) var collectionView: UICollectionView!

	public required init() {
		super.init(frame: .zero)
		
		setupSubviews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupSubviews() {
		let layout = PagingMenuCollectionViewLayout()
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(PagingMenuCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.dataSource = self
		collectionView.delegate = self

		addSubview(collectionView)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		collectionView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
		
    collectionView.reloadData()
	}
}

extension PagingMenu: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let identifier = "cell"
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PagingMenuCell

		return cell
	}
}

extension PagingMenu: UICollectionViewDelegate {
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(indexPath.item)
	}
}

extension PagingMenu: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print("scrollViewDidScroll")
  }
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		print("scrollViewWillBeginDragging")
  }
  
  public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		print("scrollViewWillEndDragging")
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		print("scrollViewDidEndDragging")
  }
  
  public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		print("scrollViewWillBeginDecelerating")
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		print("scrollViewDidEndDecelerating")
  }
  
  public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		print("scrollViewDidEndScrollingAnimation")
  }
	
	public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
		print("scrollViewDidChangeAdjustedContentInset")
	}
}
