//
//  ArtistSearchTableViewController.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Archeota
import Foundation
import UIKit

class ArtistSearchTableViewController: UITableViewController {
    
    var searchController: UISearchController?
    var searchResultsArray = [Artist]()
    var currentArtist: Artist?
    
    let kArtistListToTrackListSegue = "artistListToTrackListSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerUINib()
        setupSearchBar()
        
        self.title = "Artists"
    }
    
    fileprivate func registerUINib() {
        
        tableView.register(UINib(nibName: ArtistListTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: ArtistListTableViewCell.cellIdentifier())
    }
}

//MARK: - Table View Delegate and DataSource 
extension ArtistSearchTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistListTableViewCell.cellIdentifier(), for: indexPath) as? ArtistListTableViewCell else {
            
            LOG.warn("Error with dequeueing Artist List Table View Cell")
            return UITableViewCell()
        }
        
        let row = indexPath.row
        let artist = searchResultsArray[row]
        
        if !searchResultsArray.isEmpty {
            
            cell.configureCellWithArtist(artist)
            cell.artistNameLabel.text = artist.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentArtist = searchResultsArray[indexPath.row]
        self.performSegue(withIdentifier: kArtistListToTrackListSegue, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ArtistListTableViewCell.cellHeight()
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
        
        guard let searchText = searchBar.text else {
            
            LOG.warn("Error with search bar text")
            return
        }
        
        if searchText.isEmpty || searchText == " " {
            
            showAlert(title: "Sorry Please Search for an Aritst Name", message: "Please type in an artist name")
        }
        
        searchQuery(searchText)
    }
}

// MARK: - Private Search Methods
private extension ArtistSearchTableViewController {
    
    func searchQuery(_ searchString: String) {
        
        APIServiceManager.sharedManager.fetchArtist(searchString, completion: { (artists) in
            self.searchResultsArray = artists
            self.tableView.reloadData()
        }) { (error) in
            self.showAlert(title: "Error Displaying Artist(s)", message: "There is an error displaying your artist(s), please try again.")
            LOG.error("Error displaying artists, error description: \(error.localizedDescription)")
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

//MARK: - Segues
extension ArtistSearchTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let trackListTableViewController = segue.destination as? TrackListTableViewController {
            trackListTableViewController.currentArtist = currentArtist
        }
    }
}
