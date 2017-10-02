//
//  SpotifyAuth.swift
//  SDTestMusic
//
//  Copyright © 2017 SD. All rights reserved.
//

import Archeota
import UIKit

let SPOTIFY_CLIENT_ID = "639434934499449d804c067c83eaf53f"
let SPOTIFY_SECRET = "7913d3771aae4abcae967953a9d642ff"

class SpotifyAuth {
    
    static func requestToken() {
        
        guard var URL = URL(string: "https://accounts.spotify.com/authorize") else {return}
        
        let URLParams = [
            "client_id": "639434934499449d804c067c83eaf53f",
            "response_type": "token",
            "redirect_uri": "sdcc://authenticationcallback",
            "show_dialog": "false",
            ]
        
        URL = URL.appendingQueryParameters(URLParams)
        UIApplication.shared.openURL(URL)
    }
    
    static func refeshToken() {
        
        guard let URL = URL(string: "https://accounts.spotify.com/api/token") else {return}
        
        let Body = [
            "grant_type": "authorization_code",
            "code":  UserDefaults.standard.spotifyAuthToken()!,
            "redirect_uri": "sdcc://authenticationcallback",
            "client_secret":SPOTIFY_SECRET,
            "client_id":SPOTIFY_CLIENT_ID
        ]
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: Body, options: [])
        }
        catch let error as NSError {
            LOG.error("Error serializing the data, error description: \(error.localizedDescription)")
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if (error == nil) {
                // Success
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                
                guard let data = data else {
                    return
                }
                
                do {
                    let _ = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                }
                catch {
                    LOG.error("Error serializing JSON Object with data, error description: \(error.localizedDescription)")
                }
                
                LOG.info("URL Session Task Succeeded: HTTP \(statusCode ?? 0)")
            }
            else {
                // Failure
                LOG.error("Error URL Session Task Failed, error description: \(error?.localizedDescription ?? "can't display error")")
            }
        })
        
        task.resume()
    }
}

protocol URLQueryParameterStringConvertible {
    
    var queryParameters: String { get }
}

