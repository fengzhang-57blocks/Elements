//
//  SegmentControlViewController.swift
//  Elements
//
//  Created by 57block on 2023/1/6.
//

import UIKit

class SegmentControlViewController: BaseViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
		
		let s1Segments = makeSegments(["北京", "上海", "广州", "深圳"])
		let s1 = makeSegmentControl(s1Segments, style: .indicator, alignment: .centered)
		s1.bounds.size = CGSize(width: view.bounds.width, height: 50)
		s1.delegate = self
		navigationItem.titleView = s1
		
		
		let s2Segments = makeSegments(["北京", "上海", "广州", "深圳"])
		let s2 = makeSegmentControl(s2Segments, style: .indicator, alignment: .equalization)
		s2.bounds.size = CGSize(width: view.bounds.width, height: 50)
		s2.delegate = self
		view.addSubview(s2)
		s2.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			s2.heightAnchor.constraint(equalToConstant: 50),
			s2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			s2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			s2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
		])
		
		let s3Segments = makeSegments(["内蒙古", "呼和浩特", "新疆维吾尔自治区", "西藏", "青海省", "大美云南", "甘肃", "黑吉辽", "河西走廊"])
		let s3 = makeSegmentControl(s3Segments, style: .oval, alignment: .tiled)
		s3.bounds.size = CGSize(width: view.bounds.width, height: 50)
		s3.delegate = self
		view.addSubview(s3)
		s3.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			s3.heightAnchor.constraint(equalToConstant: 50),
			s3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			s3.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			s3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
		])
	}
	
	func makeSegments(_ titles: [String]) -> [Segment] {
		return titles.enumerated().map { index, title in
			Segment(
				title: NSAttributedString(
					string: title,
					attributes: [
						.font: UIFont.systemFont(ofSize: 15, weight: .medium),
					]
				),
				isSelected: index == 0)
		}
	}
	
	func makeSegmentControl(
		_ segments: [Segment],
		style: SegmentControl.Style,
		alignment: SegmentControl.Alignment) -> SegmentControl {
			let s = SegmentControl(segments: segments)
			s.style = style
			s.alignment = alignment
			
			var layout = SegmentControl.Layout()
			if style == .indicator {
				layout.itemSpacing = 0
				layout.titleInsets = UIEdgeInsets(horizontal: 8)
			} else {
				layout.selectedTitleColor = .white
				layout.selectedBackgroundColor = .systemBlue
			}
			s.layout = layout
			
			return s
	}
}

extension SegmentControlViewController: SegmentControlDelegate {
	func segmentControl(_ segmentControl: SegmentControl, didSelect segment: Segment, at index: Int) {
		print(segment.title.string)
	}
}
