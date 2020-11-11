//
//  SelfConfiguringCell.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation

protocol SelfConfiguringCell {
    static var identifier: String { get }
    var delegate: SearchCellDelegate? { get set }
    func configure(with mediaItem: Media)
}

protocol MediaItem {
    var mediaType: MediaType { get }
    var stringURL: String { get set }
}

