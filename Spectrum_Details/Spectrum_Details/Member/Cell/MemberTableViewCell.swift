//
//  MemberTableViewCell.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 27/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(member: Member?) {
        labelName.text = (member?.firstName ?? "") + " " + (member?.lastName ?? "")
        labelEmail.text = member?.email
    }
}
