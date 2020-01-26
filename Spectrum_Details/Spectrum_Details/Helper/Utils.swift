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

//MARK:- Set Custom Navigation Bar
extension UINavigationController {
    
    func setCustomNavigation(title: String)  {
        
        //self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.navigationBar.topItem?.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationBar.topItem?.title = title
    }
}

@IBDesignable
extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }
    }

}

