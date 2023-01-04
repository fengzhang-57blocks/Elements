//
//  SegmentControl.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class SegmentControl: UIView {
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
    collectionView.bounces = true
		return collectionView
	}()
	
	var layout: SegmentControl.Layout =
		SegmentControl.Layout() {
		didSet {
			
		}
	}
	
	var alignment: SegmentControl.Alignment = .centered {
		didSet {
			
		}
	}
	
	var style: SegmentControl.Style = .indicator {
		didSet {
			
		}
	}
	
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
		addSubview(collectionView)
    
    ("" as NSString).boundingRect(with: bounds.size, context: nil)
		
		collectionView.register(SegmentControlOvalCell.self, forCellWithReuseIdentifier: "oval")
		collectionView.register(SegmentControlIndicatorCell.self, forCellWithReuseIdentifier: "indicator")
		
		collectionView.dataSource = self
		collectionView.delegate = self
    
		addSubview(collectionView)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		switch alignment {
		case .tiled:
      collectionView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
      collectionView.frame.size = bounds.size
		case .centered:
      collectionView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
      let contentWidth = segments.reduce(0) { $0 + titleSize($1.title).width + layout.itemSpacing } + layout.horizontalSpacing * 2
      let width = CGFloat.minimum(contentWidth, bounds.width)
      if width.isEqual(to: bounds.width) {
        collectionView.contentOffset.x = (contentWidth - width) / 2
      }
      
      collectionView.frame.size = CGSize(width: width, height: bounds.height)
			break
		case .equalization:
      collectionView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
      collectionView.frame.size = bounds.size
		}
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
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
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
		cell.configure(segment)
		cell.backgroundColor = .purple
		return cell
	}
}

extension SegmentControl: UICollectionViewDelegateFlowLayout {
	func collectionView
	(_ collectionView: UICollectionView,
	 layout collectionViewLayout: UICollectionViewLayout,
	 sizeForItemAt indexPath: IndexPath) -> CGSize {
    let segment = segments[indexPath.row]
    switch alignment {
    case .tiled:
      return CGSize(width: titleSize(segment.title).width + layout.itemSpacing, height: bounds.height)
    case .centered:
      return CGSize(width: titleSize(segment.title).width + layout.itemSpacing, height: bounds.height)
    case .equalization:
      return CGSize(width: (bounds.width - layout.horizontalSpacing * 2) / CGFloat(segments.count), height: bounds.height)
    }
	}
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(horizontal: layout.horizontalSpacing)
  }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}

private extension SegmentControl {
  func titleSize(_ string: String) -> CGSize {
    return (string as NSString).boundingRect(
      with: bounds.size,
      attributes: [
        .font: layout.font,
      ],
      context: nil)
    .size
  }
}
