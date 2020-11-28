//
//  PlaylistCellContentView.swift
//  New-Music
//
//  Created by Michael McGrath on 11/27/20.
//

import UIKit

class PlaylistCellContentView: UIView, UIContentView {
    
    var configuration: UIContentConfiguration
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are my favorite!!!")
    }
    
}

//struct PlaylistContentConfiguration: UIContentConfiguration, Hashable {
//
//    var playlistName: String?
//
//
//    func makeContentView() -> UIView & UIContentView {
//        PlaylistCellContentView(configuration: self)
//    }
//
//    func updated(for state: UIConfigurationState) -> PlaylistContentConfiguration {
//        <#code#>
//    }
//
    
//}
