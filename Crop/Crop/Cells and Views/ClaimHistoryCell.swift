//
//  ClaimHistoryCell.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/23.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class ClaimHistoryCell: UITableViewCell {
    @IBOutlet weak var claimeTypeLabel: UILabel!
    @IBOutlet weak var totalAmountInsuredLabel: UILabel!
    @IBOutlet weak var policyExpireDate: UILabel!
    @IBOutlet weak var cropLabel: UILabel!
    @IBOutlet weak var premiumPaidLabel: UILabel!
    @IBOutlet weak var insuranceProviderName: UILabel!
    @IBOutlet weak var settlementAmountLabel: UILabel!
    @IBOutlet weak var settlementDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellForSettled(policiy: HoldingPolicies){
        insuranceProviderName.text =  "  " + policiy.insuranceProvider!
        totalAmountInsuredLabel.text = "  Rs " + policiy.insuredAmount!
        premiumPaidLabel.text = "  Rs " + policiy.totalPremium!
        cropLabel.text = "  " +  policiy.forCrop!
        policyExpireDate.text = "  " + policiy.startDate! + " To " + policiy.expiryDate!
        settlementDateLabel.text = "  " + policiy.settlementPaidDate!
        settlementAmountLabel.text = "  Rs " + policiy.settlementPaidAmount!
        if policiy.claimType == false {
            claimeTypeLabel.text = NSLocalizedString("   Manually processed", comment: "")
        } else {
            claimeTypeLabel.text = NSLocalizedString("   Auto processed", comment: "")
        }
        
    }
}
