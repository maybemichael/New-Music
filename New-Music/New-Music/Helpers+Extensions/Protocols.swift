//
//  Protocols.swift
//  New-Music
//
//  Created by Michael McGrath on 11/17/20.
//

import SwiftUI

protocol SelfConfiguringCell {
    static var identifier: String { get }
    var delegate: SearchCellDelegate? { get set }
    func configure(with mediaItem: Media)
}

protocol MediaItem {
    var mediaType: MediaType { get }
    var stringURL: String { get set }
}

protocol SearchCellDelegate: AnyObject {
    func addSongTapped(cell: SongsCollectionViewCell)
}
