//
//  SearchVC+UISearchBar.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import UIKit

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    var isSearchTermEmpty: Bool {
        searchController.searchBar.text?.count ?? 0 > 0 ? false : true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload(_:)), object: searchController.searchBar)
        perform(#selector(reload(_:)), with: searchController.searchBar, afterDelay: 0.5)
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchController.isActive = false
//    }
    
    @objc func reload(_ searchBar: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        MusicController.shared.searchForSongWith(searchTerm) { _ in
            self.reloadData()
        }
    }
}
