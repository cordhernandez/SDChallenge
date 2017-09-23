//
//  TrackListTableViewController.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class TrackListTableViewController: UITableViewController {
    
    var currentArtist: Artist?
    var currentTrack: Track?
    var sortedTracksDictionary = [String : [Any]]()
    var sortedAlbums = [String]()
    
    var trackDetailView: TrackDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: TrackListTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: TrackListTableViewCell.cellIdentifier())
        
        if let artist = currentArtist {
            self.title = "\(artist.name!) Tracks"
        }
        else {
            self.title = "Track"
        }
        
        getTrackData()
        setupTrackDetailView()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        
        displaySettings()
    }
}

// MARK: UITableViewDataSource
extension TrackListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sortedAlbums.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedTracksDictionary[sortedAlbums[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return TrackListTableViewCell.sectionHeaderHeight()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedAlbums[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return TrackListTableViewCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackListTableViewCell.cellIdentifier(), for: indexPath) as! TrackListTableViewCell
        let track = (sortedTracksDictionary[sortedAlbums[indexPath.section]] as! [Track])[indexPath.row]
        
        cell.configureCellWithTrack(track)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentTrack = (sortedTracksDictionary[sortedAlbums[indexPath.section]] as! [Track])[indexPath.row]
        displayTrackDetailView()
    }
    
    // MARK: - Custom Methods
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

private extension TrackListTableViewController {
    
    func displayTrackDetailView() {
        
        guard let currentTrack = currentTrack else { return }
        
        trackDetailView?.setupViewWithTrack(currentTrack)
        
        self.navigationController?.view.addSubview(trackDetailView!)
        self.navigationController?.view.bringSubview(toFront: trackDetailView!)
    }
    
    func getTrackData() {
        
        if let artist = currentArtist {
            
            APIServiceManager.sharedManager.fetchTracksWithArtistID(artist.ID!, completion: { (tracks) in
                
                let sortedTrackArray = tracks.sorted(by: {return $0.name!.compare($1.name!) == ComparisonResult.orderedAscending})
                
                self.sortedTracksDictionary = Track.sortTracksWithArray(sortedTrackArray)["sortedTracks"] as! [String : [Track]]
                self.sortedAlbums = Track.sortTracksWithArray(tracks)["sortedAlbums"] as! [String]
                self.tableView.reloadData()
                
            }, failure: { (error) in
                
            })
        }
    }
    
    func setupTrackDetailView() {
        
        trackDetailView = TrackDetailView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    }
}
