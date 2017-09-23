//
//  Alerts+.swift
//  SDTestMusic
//
//  Created by Cordero Hernandez on 9/23/17.
//  Copyright © 2017 SD. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        presentAlert(alert)
    }
    
    func presentAlert(_ alert: UIAlertController) {
        
        self.present(alert, animated: true, completion: nil)
    }
}

//This alert is specifically for the TrackDetailView class (UIView)
extension UIView {
    
    func showAlertView(title: String, message: String) {
        
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel")
        alert.show()
    }
    
}

