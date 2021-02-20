//
//  SectionFooterCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 1/8/21.
//

import UIKit

class SectionFooterCollectionViewCell: UICollectionViewListCell {
    
    
    
    let playlistDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let stackView = UIStackView(arrangedSubviews: [playlistDetailLabel])
//        stackView.distribution = .fill
//        stackView.alignment = .leading
//        addSubview(stackView)
        addSubview(playlistDetailLabel)
        playlistDetailLabel.translatesAutoresizingMaskIntoConstraints = false
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = playlistDetailLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
        top.priority = UILayoutPriority(999)
        let leading = playlistDetailLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        leading.priority = UILayoutPriority(999)
        let trailing = playlistDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        trailing.priority = UILayoutPriority(999)
        let bottom = playlistDetailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.priority = UILayoutPriority(999)
//
        let centerY = playlistDetailLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
        centerY.priority = UILayoutPriority(999)
        let centerX = playlistDetailLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
        centerX.priority = UILayoutPriority(999)
//        let height = stackView.heightAnchor.constraint(equalToConstant: contentView.bounds.height)
//        height.priority = UILayoutPriority(999)
//        let width = stackView.widthAnchor.constraint(equalToConstant: contentView.bounds.width)
//        width.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            top,
            leading,
            trailing,
            bottom
//            centerY
//            height,
//            width
//            centerX,
//            centerY
        ])
//        playlistDetailLabel.anchor(centerX: contentView.centerXAnchor, centerY: contentView.centerYAnchor, padding: .init(top: 8, left: 20, bottom: -8, right: -20))
        let date = Date()
        if date == Date() {
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards is just not my thing")
    }
    
}
