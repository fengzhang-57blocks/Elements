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
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		
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
			break
		case .centered:
			collectionView.center = CGPoint(x: center.x, y: bounds.height / 2)
			collectionView.frame.size = CGSize(width: 200, height: 100)
			break
		case .dynamic:
			break
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
		return CGSize(width: 90, height: 50)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}
