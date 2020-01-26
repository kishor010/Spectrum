//
//  ViewController.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 25/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func spectrumButtonAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyViewController") as? CompanyViewController else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setCustomNavigation(title: Utils.localizedString(forKey: Keys.spectrum))
    }
}

