//
//  ClaimeHistoryViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/23.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class ClaimeHistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let farmerKey = getDataFromUserDefault(key: FarmerData.farmerkey.rawValue)
    let farmerid = getDataFromUserDefault(key: FarmerData.aadharNumber.rawValue)
    let password = getDataFromUserDefault(key: FarmerData.passWord.rawValue)
    var holdingPoliciesArray = [HoldingPolicies]()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.backgroundColor = greenTheme
        titleLabel.roundedCorner()
        getAllSettledPolicies()
    }
    

    func getAllSettledPolicies() {
        let dictionary: [String : String] = ["contractType": ContractType.policy.rawValue, "operation": Operation.getHoldingPolicies.rawValue , "jsonObject": farmerKey ?? "", "farmerId": String(farmerid ?? "0"),"pwd": password!,"subOperation": Operation.subOperationForHClaimHistory.rawValue]
        activityIndicatorBegin()
        apicall.getAllHoldingPolicies(parameter: dictionary) { (holdingPolicies, error) in
            if holdingPolicies != nil  && holdingPolicies != nil {
                self.holdingPoliciesArray = holdingPolicies!
            }else {
                DispatchQueue.main.async {
                    self.showAlert(message: errorMessage)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicatorEnd()
                if self.holdingPoliciesArray.count == 0 {
                    self.showAlert(message: NSLocalizedString("No policies found", comment: ""))
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  holdingPoliciesArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ClaimHistoryCell = tableView.dequeueReusableCell(withIdentifier: "ClaimHistoryCell", for: indexPath) as! ClaimHistoryCell
        cell.configureCellForSettled(policiy: holdingPoliciesArray[indexPath.row])
     return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 490
    }
}
