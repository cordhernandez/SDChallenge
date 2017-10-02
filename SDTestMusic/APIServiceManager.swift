//
//  APIServiceManager.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Archeota
import Foundation

class APIServiceManager {
    
    static let sharedManager = APIServiceManager()
    private init() {}
    
    typealias ArtistCompletion = (_ artists: [Artist]) -> Void
    typealias TrackCompletion = (_ tracks: [Track]) -> Void
    typealias FailureBlock = (_ error: NSError) -> Void
    
    var showImages: Bool = true
    
    func fetchArtist(_ name: String?, completion: @escaping ArtistCompletion, failure FailureBlock: @escaping FailureBlock) {
        
        DispatchQueue.main.async {
            
            guard let artistName = name else {
                
                LOG.debug("Unable to read Artist(s) name: \(name ?? "There is no name")")
                return
            }
            
            let urlString = "https://api.spotify.com/v1/search?q=\(artistName)&type=artist"
            
            if let url = URL(string: urlString) {
                
                let session = URLSession.shared
                var request = URLRequest(url: url)
                let authToken = UserDefaults.standard.spotifyAuthToken()
                
                request.addValue("Bearer \(authToken ?? "There is no token")", forHTTPHeaderField: "Authorization")
                
                let task = session.dataTask (with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                    
                    if let error = error as NSError? {
                        
                        FailureBlock(error)
                        LOG.error("Error with the session data task, error description: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        
                        let error = NSError(domain: "No Data Returned", code: 0, userInfo: nil)
                        
                        FailureBlock(error)
                        LOG.error("Error with getting data, error description: \(error.localizedDescription)")
                        return
                    }
                    
                    do {
                        
                        guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] else {
                            
                            LOG.warn("Can't serialize data from JSON object")
                            return
                        }
                        
                        let artistArray = Artist.getArtistsWithArray((jsonDict["artists"] as? [String: Any] ?? ["" : (Any).self])["items"] as? [[String: Any]] ?? [["" : (Any).self]])
                        
                        DispatchQueue.main.async(execute: {
                            
                            completion(artistArray)
                        })
                    }
                    catch let error as NSError {
                        
                        FailureBlock(error)
                        LOG.error("Error serializing JSON object, error description: \(error.localizedDescription)")
                    }
                })
                
                task.resume()
            }
        }
    }
    
    func fetchTracksWithArtistID(_ artistID: String, completion: @escaping TrackCompletion, failure FailureBlock: @escaping FailureBlock) {
        
        DispatchQueue.main.async {
            
            let urlString = "https://api.spotify.com/v1/artists/\(artistID)/top-tracks/?country=US"
            
            if let url = URL(string: urlString) {
                
                let session = URLSession.shared
                var request = URLRequest(url: url)
                let authToken = UserDefaults.standard.spotifyAuthToken()
                
                request.addValue("Bearer \(authToken ?? "There is no token")" , forHTTPHeaderField: "Authorization")
                
                let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                    
                    if let error = error as NSError? {
                        
                        FailureBlock(error)
                        LOG.error("Error with the session data task, error description: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        
                        let error = NSError(domain: "No Data Returned", code: 0, userInfo: nil)
                        
                        FailureBlock(error)
                        LOG.error("Error with getting data, error description: \(error.localizedDescription)")
                        return
                    }
                    
                    do {
                        
                        guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] else {
                            LOG.warn("Can't serialize data from JSON object")
                            return
                        }
                        
                        let trackArray = Track.getTracksWithArray(jsonDict["tracks"] as? [[String : Any]] ?? [["" : (Any).self]])
                        
                        DispatchQueue.main.async(execute: {
                            
                            completion(trackArray)
                        })
                    }
                    catch let error as NSError {
                        
                        FailureBlock(error)
                        LOG.error("Error serializing JSON object, error description: \(error.localizedDescription)")
                    }
                })
                
                task.resume()
            }
        }
    }
}
