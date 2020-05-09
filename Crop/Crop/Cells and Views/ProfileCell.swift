//
//  ProfileCell.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/07.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var claimHistory: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.text = getDataFromUserDefault(key: FarmerData.farmerName.rawValue)
        mobileNumberLabel.text = getDataFromUserDefault(key: FarmerData.mobileNumber.rawValue)
        logOutButton.roundedCorner()
        logOutButton.backgroundColor = greenTheme
        logOutButton.setTitleColor(.white, for: .normal)
        claimHistory.roundedCorner()
        claimHistory.backgroundColor = greenTheme
        claimHistory.setTitleColor(.white, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
