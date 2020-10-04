//
//  SearchViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    let musicController = MusicController(auth: AuthController())
    let searchChildVC = SearchChildViewController()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpChildren()
    }
    
    private func setUpViews() {
        view.backgroundColor = .backgroundColor
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Albums, Artists, or Songs"
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.barTintColor = .systemGray6
        navigationController?.navigationBar.topItem?.title = "Search"
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        navBar.barStyle = .black
    }
    
    private func setUpChildren() {
        let children = [searchChildVC]
        children.forEach {
            addChild($0)
            view.addSubview($0.view)
            $0.didMove(toParent: self)
        }
        searchChildVC.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .zero)
        searchChildVC.view.backgroundColor = .backgroundColor
    }

}
