//
//  Track.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/14/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Archeota
import Foundation
import UIKit

class Track {
    
    var artistName: [Artists] = []
    var name: String?
    var album: Album
    var duration: Int?
    var popularity: Int?
    var trackNumber: Int?
    let previewURL: String?
    
    init(dictionary: [String : Any]) {
        
        name = dictionary["name"] as? String
        duration = dictionary["duration_ms"] as? Int
        popularity = dictionary["popularity"] as? Int
        trackNumber = dictionary["track_number"] as? Int
        previewURL = dictionary["preview_url"] as? String
        album = Album(from: (dictionary["album"] as? NSDictionary ?? [:]))
        
        for artist in dictionary["artists"] as? [[String : Any]] ?? [["" : (Any).self]]{
            
            let artist = Artists(artistName: artist["name"] as? String,
                                 type: artist["type"] as? String, id: artist["id"] as? String)
            
            artistName.append(artist)
        }
    }
}

struct Album {
    
    var albumType: String?
    var artists: Artists
    var id: String?
    var images: [TrackImage] = []
    var name: String?
    
    init(from albumDictionary: NSDictionary) {
        
        albumType = albumDictionary["album_type"] as? String
        artists = Artists(artistName: albumDictionary["name"] as? String, type: albumDictionary["type"] as? String, id: albumDictionary["id"] as? String)
        id = albumDictionary["id"] as? String
        name = albumDictionary["name"] as? String
        
        for image in albumDictionary["images"] as? [[String : Any]] ?? [["" : (Any).self]] {
            
            let theImages = TrackImage(height: image["height"] as? Int,
                                       width: image["width"] as? Int,
                                       url: image["url"] as? String)
            
            images.append(theImages)
        }
    }
}

struct TrackImage {
    
    var height: Int?
    var width: Int?
    var url: String?
}

struct Artists {
    
    var artistName: String?
    var type: String?
    var id: String?
}

// Instance Methods
extension Track {
    
    func formattedDuration() -> String {
        
        if let duration = self.duration {
            
            let hours = ((duration / (1000 * 60 * 60)) % 24)
            let minutes = ((duration / (1000 * 60)) % 60)
            let seconds = ((duration / 1000) % 60)
            
            let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
            let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
            let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            
            return "\(hoursString):\(minutesString):\(secondsString)"
        }
        
        return "00:00:00"
    }
    
    func thumbnailImage(_ completion: @escaping (_ image: URL) -> Void) {
        
        guard let stringURL = self.album.images[0].url else {
            
            LOG.warn("Unable to get string URL from album images")
            return
        }
        
        guard let url = URL(string: stringURL) else {
            
            LOG.warn("Unable to get URL from string URL")
            return
        }
        
        completion(url)
    }
    
    // Class Methods
    class func getTracksWithArray(_ array: [[String : Any]]) -> [Track] {
        
        var tmpArray = [Track]()
        
        for track in array {
            
            let tmpTrack = Track(dictionary: track)
            tmpArray.append(tmpTrack)
        }
        
        return tmpArray
    }
    
    class func sortTracksWithArray(_ array: [Track]) -> [String : Any] {
        
        var sortedTrackDictionary = [String : [Track]]()
        
        for (_, item) in array.enumerated() {
            
            guard let key = item.album.name else {
                
                LOG.warn("Unable to get album names")
                return sortedTrackDictionary
            }
            
            if sortedTrackDictionary[key] == nil {
                sortedTrackDictionary[key] = [Track]()
            }
            
            sortedTrackDictionary[key]?.append(item)
        }
        
        let sortedAlbumArray = Array(sortedTrackDictionary.keys).sorted()
        
        return ["sortedTracks" : sortedTrackDictionary, "sortedAlbums" : sortedAlbumArray]
    }
}
