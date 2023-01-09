//
//  SegmentControl.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class SegmentControl: UIView {
	
	var layout: SegmentControl.Layout = SegmentControl.Layout() {
		didSet {
			collectionView.reloadData()
		}
	}
	
	var alignment: SegmentControl.Alignment = .centered
	
	var style: SegmentControl.Style = .indicator
  
  var dataSource: SegmentControlDataSource?
  var delegate: SegmentControlDelegate?
	
	private(set) var collectionView: UICollectionView!
	
	private var selectedSegment: Segment?
	
	var segments: [Segment]
	init(segments: [Segment] = []) {
		self.segments = segments
		super.init(frame: .zero)
		
		selectedSegment = segments.filter({
			$0.isSelected
		}).first
	
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
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		if let selectedSegment = selectedSegment, let index = segments.firstIndex(of: selectedSegment) {
			let indexPath = IndexPath(item: index, section: 0)
			collectionView.selectItem(
				at: indexPath,
				animated: false,
				scrollPosition: .centeredHorizontally
			)
			handleSelectSegment(selectedSegment, at: indexPath)
		}
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
				layout.contentInsets.horizontal +
				$0 +
				$1.title.boundingRectSize(bounds.size).width
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
		
		selectedSegment = segments.filter({
			$0.isSelected
		}).first
		
    collectionView.reloadData()
	}
	
	func reloadData() {
		collectionView.reloadData()
	}
}

extension SegmentControl: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let dataSource = dataSource {
      return dataSource.numberOfItemsInSegmentControl(self)
    }
    
		return segments.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let dataSource = dataSource {
      return dataSource.segmentControl(self, cellForItemAt: indexPath.item)
    }
    
		var identifier = "oval"
		if style == .indicator {
			identifier = "indicator"
		}
		let segment = segments[indexPath.item]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SegmentControlCell
		cell.configure(segment, layout: layout)
		
		return cell
	}
}

extension SegmentControl: UICollectionViewDelegateFlowLayout {
	func collectionView
	(_ collectionView: UICollectionView,
	 layout collectionViewLayout: UICollectionViewLayout,
	 sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let size = delegate?.segmentControl(self, layout: collectionViewLayout, sizeForItemAt: indexPath.item),
				!size.equalTo(.zero) {
      return size
    }
    
    switch alignment {
		case .tiled, .centered:
			return CGSize(
				width: segments[indexPath.item].title.boundingRectSize(bounds.size).width + layout.contentInsets.horizontal,
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
  
	func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
			if let spacing = delegate?.minimumInteritemSpacingForSegmentControl(self, layout: collectionViewLayout),
					!spacing.isEqual(to: .zero) {
        return spacing
      }
      
      return layout.itemSpacing
	}
	
	func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      if let spacing = delegate?.minimumInteritemSpacingForSegmentControl(self, layout: collectionViewLayout),
				 !spacing.isEqual(to: .zero) {
        return spacing
      }
      
      return layout.itemSpacing
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let segment = segments[indexPath.item]
		
		if let selectedSegment = selectedSegment,
			 selectedSegment.isEqual(to: segment),
				!layout.isRepeatTouchEnabled {
			return
		}
		
		selectedSegment = segment
		segments = segments.map { s in
      var nexts = s
      nexts.isSelected = segment.title.isEqual(to: s.title)
      return nexts
    }
    
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    collectionView.reloadData()
    
    handleSelectSegment(segment, at: indexPath)
	}
}

private extension SegmentControl {
	func handleSelectSegment(_ segment: Segment, at indexPath: IndexPath) {
		if let actionHandler = segment.handler {
			actionHandler(segment)
		} else if let delegate = delegate {
			delegate.segmentControl(self, didSelect: segment, at: indexPath.item)
		}
	}
}
