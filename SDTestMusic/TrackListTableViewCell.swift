//
//  TrackListTableViewCell.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class TrackListTableViewCell: UITableViewCell {
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var trackDurationLabel: UILabel!
    
    static let cellId = "TrackListTableViewCell"
    
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
    
    class func sectionHeaderHeight() -> CGFloat {
        return 44.0
    }
}

extension TrackListTableViewCell {
    func configureCellWithTrack(_ track: Track) {
        trackNameLabel.text = track.name
        trackDurationLabel.text = track.formattedDuration()
        track.thumbnailImage { (image) in
            self.trackImageView.image = image
        }
    }
}
