//
//  URL+.swift
//  SDTestMusic
//
//  Copyright © 2017 SD. All rights reserved.
//

import Foundation


let SPOTIFY_AUTH_TOKEN_KEY = "SPOTIFY_AUTH_TOKEN_KEY"


extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        
        var parts: [String] = []
        
        for (key, value) in self {
            
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "-N/A-",
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "-N/A-")
            
            parts.append(part as String)
        }
        
        return parts.joined(separator: "&")
    }
    
}


extension String {
    
    func base64Encoded() -> String? {
        
        if let data = data(using: .utf8) {
            return data.base64EncodedString()
        }
        
        return nil
    }
    
    func trimmed() -> String {
        
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func escaped() -> String {
        
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? "-N/A-"
    }
}


extension URL {
    
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
    
    var fragments: [String: String] {
        
        var results = [String: String]()
        
        if let pairs = fragment?.components(separatedBy: "&") {
            
            for pair: String in pairs {
                
                if let keyValue = pair.components(separatedBy:"=") as [String]? {
                    results.updateValue(keyValue[1], forKey: keyValue[0])
                }
            }
        }
        
        return results
    }
}


extension UserDefaults {
    
    var hasSpotifyToken:Bool {
        
        return spotifyAuthToken() != nil
    }
    
    func spotifyAuthToken() -> String? {
        
        return string(forKey: SPOTIFY_AUTH_TOKEN_KEY)
    }
    
    func saveSpotifyAuth(token:String) {
        
        set(token, forKey:SPOTIFY_AUTH_TOKEN_KEY)
        synchronize()
    }
}
