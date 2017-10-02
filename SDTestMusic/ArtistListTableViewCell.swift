//
//  ArtistListTableViewCell.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import Kingfisher
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
        
        artist.thumbnailImage { (url) in
            
            let fade = KingfisherOptionsInfoItem.transition(.fade(0.8))
            let scale = KingfisherOptionsInfoItem.scaleFactor(UIScreen.main.scale * 2)
            let options: KingfisherOptionsInfo = [fade, scale]
            
            self.artistImageView.kf.setImage(with: url, placeholder: nil, options: options, progressBlock: nil, completionHandler: nil)
        }
    }
}
