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
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGrayThree
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGrayThree
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [topSeparatorView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill

        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: -8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards suck")
    }
}
