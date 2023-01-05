//
//  ViewController.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let segments = ["Swift", "Objective-c", "Javascript", "Goland", "PHP", "HTML"].map {
			Segment(title: NSAttributedString(string: $0, attributes: [
				.font: UIFont.systemFont(ofSize: 15, weight: .medium),
				.foregroundColor: UIColor.white
			]))
		}
		let segmentControl = SegmentControl(segments: segments)
		segmentControl.translatesAutoresizingMaskIntoConstraints = false
		segmentControl.backgroundColor = .orange
		
		segmentControl.alignment = .tiled
    
//    segmentControl.style = .oval
		
		view.addSubview(segmentControl)
		
		NSLayoutConstraint.activate([
			segmentControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			segmentControl.heightAnchor.constraint(equalToConstant: 50),
		])
	}


}

