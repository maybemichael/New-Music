//
//  SelfConfiguringCell.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation

protocol SelfConfiguringCell {
    static var identifier: String { get }
    
    func configure(with song: Song)
}
