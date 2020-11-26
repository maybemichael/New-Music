//
//  Protocols.swift
//  New-Music
//
//  Created by Michael McGrath on 11/17/20.
//

import SwiftUI

protocol SelfConfiguringCell {
    static var identifier: String { get }
    var mediaImageView: UIImageView { get }
    var delegate: SearchCellDelegate? { get set }
    func configure(with mediaItem: Media)
}

protocol MediaItem {
    var mediaType: MediaType { get }
    var stringURL: String { get set }
    var id: String { get }
}

protocol SearchCellDelegate: AnyObject {
    func addSongTapped(cell: SongsCollectionViewCell)
}

protocol CreatePlaylistDelegate: AnyObject {
    func reloadData()
}
