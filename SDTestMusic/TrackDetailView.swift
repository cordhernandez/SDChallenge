//
//  TrackDetailView.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/16/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit
import AVFoundation

class TrackDetailView: UIView {
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var trackNumberLabel: UILabel!
    @IBOutlet var trackDurationLabel: UILabel!
    @IBOutlet var trackPopularityLabel: UILabel!
    @IBOutlet var audioToolbar: UIToolbar!
    @IBOutlet var progressBar: UIProgressView!
    
    var audioPlayer: AVAudioPlayer?
    var currentTrack: Track!
    var timer: Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xibView: UIView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)![0] as! UIView
        xibView.frame = frame
        self.addSubview(xibView)
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TrackDetailView.dismissView))
        self.shadowView.addGestureRecognizer(gestureRecognizer)
        
        self.progressBar.progress = 0.0
        
        audioToolbar.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackDetailView: AVAudioPlayerDelegate {
    // Custom Methods
    func dismissView() {
        
        self.trackImageView.image = nil
        self.audioPlayer?.stop()
        self.removeFromSuperview()
    }
    
    func downloadTrack(_ track: Track, completion: @escaping () -> Void, failure failureBlock: @escaping (_ error: NSError) -> Void) {
        
        DispatchQueue(label: "getTrack", attributes: []).async {
            
            guard let stringPreviewURL = track.previewURL else { return }
            guard let previewURL = URL(string: stringPreviewURL) else { return }
            
            if let data = try? Data(contentsOf: previewURL) {
                
                do {
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    DispatchQueue.main.async(execute: {
                        completion()
                    })
                }
                catch let error as NSError {
                    self.showAlertView(title: "Error Downloading Track(s)", message: "There is an error downloading your track(s), please try again")
                    failureBlock(error)
                }
            }
            
        }
    }
    
    func setupViewWithTrack(_ track: Track) {
        
        downloadTrack(track, completion: {
            
            self.audioToolbar.isHidden = false
            self.audioPlayer?.delegate = self
            self.audioPlayer?.numberOfLoops = 0
            self.audioPlayer?.volume = 0.5
        }) { (error) in
            self.showAlertView(title: "Error Displaying Track(s)", message: "There is an error displaying your track(s), please try again")
            print(error.localizedDescription)
        }
        
        track.thumbnailImage { (url) in
            self.trackImageView.kf.setImage(with: url)
        }
        
        //        artistNameLabel.text = track.artistName.name?.uppercased() ?? "Artist name is unavailable"
        
        trackNameLabel.text = "Track Name: \(track.name ?? "unavailable")"
        trackNumberLabel.text = "Track #: \(track.trackNumber ?? 0)"
        trackDurationLabel.text = "Duration: \(track.formattedDuration())"
        trackPopularityLabel.text = "Popularity: \(track.popularity ?? 0)"
    }
    
    func updateProgressBar() {
        
        Operation.instance.async.addOperation {
            
            guard let audioPlayer = self.audioPlayer else { return }
            let currentProgress = audioPlayer.currentTime / audioPlayer.duration
            
            Operation.instance.main.addOperation {
                self.progressBar.progress = Float(currentProgress)
            }
        }
    }
    
    // Actions
    @IBAction func playTrackButtonClicked(_ sender: UIBarButtonItem) {
        
        self.audioPlayer?.play()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TrackDetailView.updateProgressBar), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    @IBAction func pauseTrackButtonClicked(_ sender: UIBarButtonItem) {
        
        self.audioPlayer?.pause()
        self.timer.invalidate()
    }
    
}

