//
//  ArtistListTableViewCell.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class ArtistListTableViewCell: UITableViewCell {
    @IBOutlet var artistImageView: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    
    static let cellId = "ArtistListTableViewCell"
    
    //MARK: - Class Methods
    class func cellIdentifier() -> String {
        return cellId
    }
    
    class func cellName() -> String {
        return cellId
    }
    
    class func cellHeight() -> CGFloat {
        return 66.0
    }
}

extension ArtistListTableViewCell {
    
    func configureCellWithArtist(_ artist: Artist) {
        
        artistNameLabel.text = artist.name
        artist.thumbnailImage { (image) in
            self.artistImageView.image = image
        }
    }
}
