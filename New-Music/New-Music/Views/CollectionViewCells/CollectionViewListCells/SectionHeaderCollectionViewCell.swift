//
//  SectionHeaderCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 1/7/21.
//

import UIKit

class SectionHeaderCollectionViewCell: UICollectionViewListCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.distribution = .fill
        stackView.alignment = .leading
        addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
//        top.priority = UILayoutPriority(999)
//        let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
//        leading.priority = UILayoutPriority(999)
//        let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//        trailing.priority = UILayoutPriority(999)
//        let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        bottom.priority = UILayoutPriority(999)
//        NSLayoutConstraint.activate([
//            top,
//            leading,
//            trailing,
//            bottom
//        ])
		stackViewConstraints(stackView: stackView, contentView: contentView)
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        separatorLayoutGuide.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true 
//        self.contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("I will fight you storyboards")
    }
}
