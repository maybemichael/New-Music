//
//  UIView+Constraints.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, bottom: superview?.bottomAnchor, centerX: superview?.centerXAnchor, centerY: superview?.centerYAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func removeConstraints() {
        self.constraints.forEach {
            self.removeConstraint($0)
        }
    }
}

// This is used to add constraints to the stack view of the collection view cells
public func stackViewConstraints(stackView: UIStackView, contentView: UIView) {
	stackView.translatesAutoresizingMaskIntoConstraints = false
	let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
	top.priority = UILayoutPriority(999)
	let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
	leading.priority = UILayoutPriority(999)
	let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
	trailing.priority = UILayoutPriority(999)
	let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
	bottom.priority = UILayoutPriority(999)

	NSLayoutConstraint.activate([
		top,
		leading,
		trailing,
		bottom
	])
}
