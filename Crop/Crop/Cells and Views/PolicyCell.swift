//
//  PolicyCell.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/07.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class PolicyCell: UITableViewCell {
    @IBOutlet weak var sumAssuranceTitleLabel: UILabel!
    @IBOutlet weak var sumAssuranceValueLabel: UILabel!
    @IBOutlet weak var premiumTitleLabel: UILabel!
    @IBOutlet weak var cropValueLabel: UILabel!
    @IBOutlet weak var cropTitleLabel: UILabel!
    
    @IBOutlet weak var buyPolicyButton: UIButton!
    @IBOutlet weak var policyPeriodValueLabel: UILabel!
    @IBOutlet weak var policyPeriodTitleLabel: UILabel!
    @IBOutlet weak var premiumValueLabel: UILabel!
    @IBOutlet weak var insuranceCompanyNameLabel: UILabel!
    @IBOutlet weak var insuranceCompanyTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initialization() {
        sumAssuranceValueLabel.textColor = greenTheme
        cropValueLabel.textColor = greenTheme
        policyPeriodValueLabel.textColor = greenTheme
        premiumValueLabel.textColor = greenTheme
        insuranceCompanyNameLabel.textColor = greenTheme
        buyPolicyButton.roundedCorner()
        buyPolicyButton.backgroundColor = greenTheme
        buyPolicyButton.setTitleColor(.white, for: .normal)
        contentView.borderAndCornerRadius()
    }
    
    func configureCellForBuy(policiy: Policies){
        let titleOfButton = NSLocalizedString("Buy Policy", comment: "")
        buyPolicyButton.setTitle(titleOfButton, for: .normal)
        insuranceCompanyNameLabel.text = "  " + policiy.insuranceProvider!
        sumAssuranceValueLabel.text = "  Rs " + String(policiy.insuredAmount ?? "0")
        premiumValueLabel.text = "  Rs " + String(policiy.premiumAmountPerHector ?? "0")
        cropValueLabel.text = "  " +  policiy.forCrop!
    }
    
    func configureCellForHolding(policiy: HoldingPolicies){
        let titleOfButton = NSLocalizedString("Manual Claim Policy", comment: "")
        buyPolicyButton.setTitle(titleOfButton, for: .normal)
        insuranceCompanyNameLabel.text = "  " + policiy.insuranceProvider!
        sumAssuranceValueLabel.text = "  Rs " + policiy.insuredAmount!
        premiumValueLabel.text = "  Rs " + policiy.totalPremium!
         cropValueLabel.text = "  " +  policiy.forCrop!
        policyPeriodValueLabel.text = "  " + policiy.startDate! + " To " + policiy.expiryDate!
    }

}
