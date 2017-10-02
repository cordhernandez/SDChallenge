//
//  TrackListTableViewController.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Archeota
import Foundation
import UIKit

class TrackListTableViewController: UITableViewController {
    
    var currentArtist: Artist?
    var currentTrack: Track?
    var trackDetailView: TrackDetailView?
    var sortedTracksDictionary = [String : [Any]]()
    var sortedAlbums = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerUINib()
        getTrackData()
        setupTrackDetailView()
    }
    
    fileprivate func configureTitle() {
        
        if let artist = currentArtist {
            self.title = "\(artist.name ?? "Artist name is unavailable") Tracks"
        }
        else {
            self.title = "Track"
        }
    }
    
    fileprivate func registerUINib() {
        
        tableView.register(UINib(nibName: TrackListTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: TrackListTableViewCell.cellIdentifier())
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        
        displaySettings()
    }
}

// MARK: UITableViewDataSource and UITableViewDelegate
extension TrackListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sortedAlbums.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedTracksDictionary[sortedAlbums[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackListTableViewCell.cellIdentifier(), for: indexPath) as? TrackListTableViewCell else {
            
            LOG.warn("Error dequeueing Track List Table View Cell")
            return UITableViewCell()
        }
        
        let row = indexPath.row
        let section = indexPath.section
        let track = (sortedTracksDictionary[sortedAlbums[section]] as! [Track])[row]
        
        cell.configureCellWithTrack(track)
        cell.trackNameLabel.text = track.name
        cell.trackDurationLabel.text = track.formattedDuration()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentTrack = (sortedTracksDictionary[sortedAlbums[indexPath.section]] as! [Track])[indexPath.row]
        displayTrackDetailView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return TrackListTableViewCell.cellHeight()
    }
}

//MARK: - TableView Header Delegates
extension TrackListTableViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedAlbums[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return TrackListTableViewCell.sectionHeaderHeight()
    }
    
}

// MARK: - Display Settings
private extension TrackListTableViewController {
    
    func displaySettings() {
        
        let alertController = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Show Images", style: UIAlertActionStyle.default, handler: { (alertAction: UIAlertAction) in
            APIServiceManager.sharedManager.showImages = true
        }))
        
        alertController.addAction(UIAlertAction(title: "Hide Images", style: UIAlertActionStyle.default, handler: { (alertAction: UIAlertAction) in
            APIServiceManager.sharedManager.showImages = false
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
//MARK: - Track Data
private extension TrackListTableViewController {
    
    func getTrackData() {
        
        if let artist = currentArtist {
            
            APIServiceManager.sharedManager.fetchTracksWithArtistID(artist.ID ?? "ID is unavailable", completion: { (tracks) in
                
                let sortedTrackArray = tracks.sorted(by: {return $0.name!.compare($1.name!) == ComparisonResult.orderedAscending})
                
                self.sortedTracksDictionary = Track.sortTracksWithArray(sortedTrackArray)["sortedTracks"] as? [String : [Track]] ?? ["" : [Track(dictionary: ["" : "" as Any]) as Any]]
                self.sortedAlbums = Track.sortTracksWithArray(tracks)["sortedAlbums"] as? [String] ?? [""]
                
                self.tableView.reloadData()
                
            }, failure: { (error) in
                
                self.showAlert(title: "Error Displaying Track(s)", message: "There is an error displaying your track(s), please try again.")
                LOG.error("Error Displaying Tracks, error description: \(error.localizedDescription)")
            })
        }
    }
}

//MARK: - Displaying Track Detail View
private extension TrackListTableViewController {
    
    func displayTrackDetailView() {
        
        guard let currentTrack = currentTrack else {
            
            LOG.warn("Error with current Track")
            return
        }
        guard let trackDetailView = trackDetailView else {
            
            LOG.warn("Error with Track Detail View")
            return
        }
        
        trackDetailView.setupViewWithTrack(currentTrack)
        
        self.navigationController?.view.addSubview(trackDetailView)
        self.navigationController?.view.bringSubview(toFront: trackDetailView)
    }
    
    func setupTrackDetailView() {
        
        trackDetailView = TrackDetailView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    }
}
