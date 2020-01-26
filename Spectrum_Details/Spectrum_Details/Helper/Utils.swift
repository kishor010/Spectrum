//
//  Utils.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 26/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class Utils {
    
    static let PROGRESS_INDICATOR_VIEW_TAG:Int = 10
    
    static func showAlert(AlertTitle : String, AlertMessage : String, controller: UIViewController) {
        let alert = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.localizedString(forKey: Keys.alertOK), style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
   static func localizedString(forKey key: String) -> String {
        var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)

        if result == key {
            result = Bundle.main.localizedString(forKey: key, value: nil, table: "Default")
        }

        return result
    }
}


