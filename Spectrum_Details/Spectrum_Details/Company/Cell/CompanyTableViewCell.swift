//
//  CompanyTableViewCell.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 26/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit
import SDWebImage

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var companyLinkButtom: UIButton!
    @IBOutlet weak var companyDescription: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(data: CompanyModel?)  {
        companyName.text = data?.name
        companyDescription.text = data?.companyDescription
        
        if let logoURL = data?.logo {
            imageLogo.sd_setImage(with: URL(string: logoURL), placeholderImage: UIImage(named: "Company_Placeholder"))
        }
        else {
            imageLogo.image = UIImage(named: "Company_Placeholder")
        }
    }
}
