//
//  SegmentControl.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class SegmentControl: UIView {
	
	private var collectionView: UICollectionView!
	
	var layout: SegmentControl.Layout = SegmentControl.Layout()
	
	var alignment: SegmentControl.Alignment = .centered
	
	var style: SegmentControl.Style = .indicator
	
	var segments: [Segment]
	init(segments: [Segment] = []) {
		self.segments = segments
		super.init(frame: .zero)
	
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupSubviews() {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false
		
		collectionView.register(SegmentControlOvalCell.self, forCellWithReuseIdentifier: "oval")
		collectionView.register(SegmentControlIndicatorCell.self, forCellWithReuseIdentifier: "indicator")
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.bounces = true
		
		addSubview(collectionView)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		switch alignment {
		case .centered:
			var cellSpacings: CGFloat = 0
			if segments.count > 0 {
				cellSpacings = CGFloat(segments.count - 1) * layout.itemSpacing
			}
			
			let contentWidth = segments.reduce(0) {
				$0 +
				titleSize($1.title).width +
				layout.contentInsets.horizontal
			} + cellSpacings
      let realWidth = CGFloat.minimum(contentWidth, bounds.width)
      if realWidth.isEqual(to: bounds.width) {
				print(-half(contentWidth - realWidth))
        collectionView.contentOffset.x = half(contentWidth - realWidth)
      }
			
      collectionView.frame.size = CGSize(width: realWidth, height: bounds.height)
		case .tiled, .equalization:
			collectionView.frame.size = bounds.size
		}
		
		collectionView.center = CGPoint(x: half(bounds.width), y: half(bounds.height))
	}
	
	func reloadSegments(_ segments: [Segment]) {
		self.segments = segments
		reloadData()
	}
	
	func reloadData() {
		collectionView.reloadData()
		
		layoutIfNeeded()
	}
}

extension SegmentControl: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return segments.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var identifier = "oval"
		if style == .indicator {
			identifier = "indicator"
		}
		let segment = segments[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SegmentControlCell
		cell.configure(segment, layout: layout)
		cell.backgroundColor = .purple
		return cell
	}
}

extension SegmentControl: UICollectionViewDelegateFlowLayout {
	func collectionView
	(_ collectionView: UICollectionView,
	 layout collectionViewLayout: UICollectionViewLayout,
	 sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch alignment {
		case .tiled, .centered:
			return CGSize(
				width: titleSize(segments[indexPath.row].title).width + layout.contentInsets.horizontal,
				height: bounds.height
			)
    case .equalization:
      return CGSize(
				width: (
					bounds.width - CGFloat(segments.count - 1) * layout.itemSpacing
				) / CGFloat(segments.count),
				height: bounds.height
			)
    }
	}
  
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return layout.itemSpacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return layout.itemSpacing
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}

private extension SegmentControl {
  func titleSize(_ straing: NSAttributedString) -> CGSize {
		return straing.boundingRect(
			with: bounds.size,
			options: [.usesLineFragmentOrigin, .usesFontLeading],
			context: nil
		).size
  }
}
