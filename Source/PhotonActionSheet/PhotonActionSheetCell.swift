//
//  PhotonActionSheetCell.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

public class PhotonActionSheetCell: UITableViewCell {
	public struct UX {
    static let iconSize: CGFloat = 24
    static let verticalPadding: CGFloat = 5
    static let horizontalPadding: CGFloat = 20
    static let labelFont: UIFont = .systemFont(ofSize: 16)
    static let labelColor: UIColor = .black
  }
  
  lazy var titleLabel = UILabel()
  
  lazy var iconImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    stackView.addArrangedSubview(iconImageView)
    stackView.addArrangedSubview(titleLabel)
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UX.verticalPadding),
      stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -UX.horizontalPadding),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UX.verticalPadding),
      stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UX.horizontalPadding),
    ])
    
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      iconImageView.heightAnchor.constraint(equalToConstant: UX.iconSize),
      iconImageView.widthAnchor.constraint(equalToConstant: UX.iconSize),
    ])
    
    titleLabel.font = UX.labelFont
    titleLabel.textColor = UX.labelColor
    titleLabel.adjustsFontSizeToFitWidth = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with action: PhotonAction) {
    titleLabel.attributedText = action.title
    accessoryView = action.isSelected ? UIImageView(image: UIImage.fromBundle("PhotonActionSheet", imageName: "checked")) : nil
    if action.isEnabled {
      selectionStyle = .default
      isUserInteractionEnabled = true
      titleLabel.textColor = UX.labelColor
    } else {
      selectionStyle = .none
      isUserInteractionEnabled = false
      titleLabel.textColor = UX.labelColor.withAlphaComponent(0.3)
    }
    switch action.iconType {
    case .image:
      iconImageView.image = action.iconImage
    case .url:
      break
    default:
      break
    }
  }
	
}
