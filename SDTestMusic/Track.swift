//
//  Track.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/14/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class Track {
    
    var name: String?
    var album: String?
    var artistName: String?
    var duration: Int? = 0
    var popularity: Int? = 0
    var trackNumber: Int?
    var previewUrl: URL?
    var imageUrls: [TrackImage] = []
    
    struct TrackImage {
        
        var height: Int? = 0
        var width: Int? = 0
        var url: URL?
    }
    
    init(dictionary: [String : Any]) {
        
        name = dictionary["name"] as? String
        album = dictionary["album_type"] as? String
        artistName = dictionary[""] as? String
        duration = 0
        popularity = 0
        trackNumber = 0
        previewUrl = URL(string: "")
        imageUrls = [TrackImage]()
    }
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
    
    func thumbnailImage(_ completion: @escaping (_ image: UIImage?) -> Void) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: {
            
            var image = UIImage(named: "musicImage")
            
            if !self.imageUrls.isEmpty {
                if let url = self.imageUrls[0].url {
                    if let imageData = try? Data(contentsOf: url) {
                        if let tmpImage = UIImage(data: imageData) {
                            image = tmpImage
                        }
                    }
                }
            }
            
            DispatchQueue.main.async(execute: {
                completion(image)
            })
        })
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
            
            let key = item.album!
            
            if sortedTrackDictionary[key] == nil {
                
                sortedTrackDictionary[key] = [Track]()
            }
            
            sortedTrackDictionary[key]?.append(item)
        }
        
        let sortedAlbumArray = Array(sortedTrackDictionary.keys).sorted()
        
        return ["sortedTracks" : sortedTrackDictionary, "sortedAlbums" : sortedAlbumArray]
    }
}
