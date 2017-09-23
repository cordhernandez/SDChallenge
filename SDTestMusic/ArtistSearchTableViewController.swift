//
//  ArtistSearchTableViewController.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class ArtistSearchTableViewController: UITableViewController {
    
    let kArtistListToTrackListSegue = "artistListToTrackListSegue"
    
    var searchController: UISearchController?
    var searchResultsArray = [Artist]()
    var currentArtist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ArtistListTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: ArtistListTableViewCell.cellIdentifier())
        
        self.title = "Artists"
        setupSearchBar()
    }
}

extension ArtistSearchTableViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let trackListTableViewController = segue.destination as? TrackListTableViewController {
            trackListTableViewController.currentArtist = currentArtist
        }
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultsArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ArtistListTableViewCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistListTableViewCell.cellIdentifier(), for: indexPath) as? ArtistListTableViewCell else {
            return UITableViewCell()
        }
        
        if !searchResultsArray.isEmpty {
            
            let artist = searchResultsArray[indexPath.row]
            cell.configureCellWithArtist(artist)
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentArtist = searchResultsArray[indexPath.row]
        self.performSegue(withIdentifier: kArtistListToTrackListSegue, sender: self)
    }
}

// MARK: - Search Bar Delegate
extension ArtistSearchTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchResultsArray.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchResultsArray.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchQuery(searchBar.text!)
    }
}

// MARK: - Private Methods
private extension ArtistSearchTableViewController {
    
    func searchQuery(_ searchString: String) {
        
        self.searchResultsArray.removeAll()
        self.tableView.reloadData()
        
        APIServiceManager.sharedManager.fetchArtist(searchString, completion: { (artists) in
            self.searchResultsArray = artists
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setupSearchBar() {
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.searchBar.delegate = self
        self.tableView.tableHeaderView = self.searchController?.searchBar
        self.definesPresentationContext = true
        self.searchController?.searchBar.sizeToFit()
        self.searchController?.searchBar.placeholder = "Search Artists"
    }
}
