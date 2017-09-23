//
//  APIServiceManager.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation

class APIServiceManager {
    
    static let sharedManager = APIServiceManager()
    
    var showImages: Bool = true
    
    func fetchArtist(_ name: String?, completion: @escaping (_ artists: [Artist]) -> Void, failure FailureBlock: @escaping (_ error: NSError) -> Void) {
        
        DispatchQueue.main.async {
            
            guard let artistName = name else {
                return
            }
            
            let urlString = "https://api.spotify.com/v1/search?q=\(artistName)&type=artist"
            
            if let url = URL(string: urlString) {
                
                let session = URLSession.shared
                var request = URLRequest(url: url)
                let authToken = UserDefaults.standard.spotifyAuthToken()
                
                request.addValue("Bearer \(authToken ?? "-N/A-")", forHTTPHeaderField: "Authorization")
                
                let task = session.dataTask (with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                    
                    if let error = error as NSError? {
                        
                        FailureBlock(error)
                        return
                    }
                    
                    guard let data = data else {
                        
                        let error = NSError(domain: "No Data Returned", code: 0, userInfo: nil)
                        FailureBlock(error)
                        
                        return
                    }
                    
                    do {
                        
                        let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                        let artistArray = Artist.getArtistsWithArray((jsonDict["artists"] as! [String: Any])["items"] as! [[String: Any]])
                        
                        print(jsonDict)
                        DispatchQueue.main.async(execute: {
                            
                            completion(artistArray)
                        })
                    }
                    catch let error as NSError {
                        
                        FailureBlock(error)
                    }
                })
                
                task.resume()
            }
        }
    }
    
    func fetchTracksWithArtistID(_ artistID: String, completion: @escaping (_ tracks: [Track]) -> Void, failure FailureBlock: @escaping (_ error: NSError) -> Void) {
        
        DispatchQueue.main.async {
            
            let urlString = "https://api.spotify.com/v1/artists/\(artistID)/top-tracks/?country=US"
            
            if let url = URL(string: urlString) {
                
                let session = URLSession.shared
                var request = URLRequest(url: url)
                let authToken = UserDefaults.standard.spotifyAuthToken()
                
                request.addValue("Bearer \(authToken ?? "-N/A-")", forHTTPHeaderField: "Authorization")
                
                let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                    
                    if let error = error as NSError? {
                        
                        FailureBlock(error)
                        return
                    }
                    
                    guard let data = data else {
                        
                        let error = NSError(domain: "No Data Returned", code: 0, userInfo: nil)
                        FailureBlock(error)
                        return
                    }
                    
                    do {
                        
                        let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
                        let trackArray = Track.getTracksWithArray(jsonDict?["tracks"] as! [[String : Any]])
                        
                        DispatchQueue.main.async(execute: {
                            
                            completion(trackArray)
                        })
                    }
                    catch let error as NSError {
                        
                        FailureBlock(error)
                    }
                })
                
                task.resume()
            }
        }
    }
}
