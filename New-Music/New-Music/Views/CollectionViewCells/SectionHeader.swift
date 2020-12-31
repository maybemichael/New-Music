//
//  SectionHeader.swift
//  New-Music
//
//  Created by Michael McGrath on 11/11/20.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
        return label
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.heightAnchor.constraint(equalToConstant: 0.3333333333333333).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topSeparatorView)
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: -20))
        topSeparatorView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: UIScreen.main.bounds.width, height: 0.3333333333333333))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards suck")
    }
}
