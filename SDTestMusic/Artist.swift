//
//  Artist.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/14/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class Artist {
    
    var name: String?
    var ID: String?
    var followers: Int? = 0
    var popularity: Int? = 0
    var imageUrls: [ArtistImage] = []
    
    struct ArtistImage {
        
        var height: Int? = 0
        var width: Int? = 0
        var url: URL?
    }
    
    init(dictionary: [String : Any]) {
        
        name = dictionary["name"] as? String
        ID = dictionary["id"] as? String
        popularity = dictionary["popularity"] as? Int
        followers = dictionary["followers"] as? Int
        
        for image in dictionary["images"] as! [[String : Any]] {
            let artistImage = ArtistImage(height: image["height"] as? Int, width: image["width"] as? Int, url: URL(string: image["url"] as! String))
            imageUrls.append(artistImage)
        }
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
    
    class func getArtistsWithArray(_ array: [[String : Any]]) -> [Artist] {
        
        var tmpArray = [Artist]()
        
        for artist in array {
            
            let tmpArtist = Artist(dictionary: artist)
            tmpArray.append(tmpArtist)
        }
        
        return tmpArray
    }
}
