//
//  URLTableViewCell.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import UIKit

final class URLTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "URLTableViewCell"
  
  private let urlLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.lineBreakMode = .byTruncatingMiddle
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with item: URLItem) {
    urlLabel.text = item.url.absoluteString
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    urlLabel.text = nil
  }
  
  private func setupLayout() {
    contentView.addSubview(urlLabel)
    
    NSLayoutConstraint.activate([
      urlLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      urlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
    ])
  }
}
