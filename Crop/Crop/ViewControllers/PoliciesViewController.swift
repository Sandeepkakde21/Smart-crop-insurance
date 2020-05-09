//
//  PoliciesViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/07.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class PoliciesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var headerBackView: UIView!
    var activePoliciesArray = [Policies]()
    var holdingPoliciesArray = [HoldingPolicies]()
    let farmerKey = getDataFromUserDefault(key: FarmerData.farmerkey.rawValue)
    let farmerid = getDataFromUserDefault(key: FarmerData.aadharNumber.rawValue)
    let password = getDataFromUserDefault(key: FarmerData.passWord.rawValue)
    
    var isBuyPolicySelected = true
    override func viewDidLoad() {
        ControllerTitle = NSLocalizedString("Policies", comment: "")
        setFarmerProfile()
        super.viewDidLoad()
        hideNavigationBackButton(value: true)
        initialization()
        getAllActivePolicies()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0 {
            isBuyPolicySelected = true
            getAllActivePolicies()
        } else {
            isBuyPolicySelected = false
            getAllHoldingPolicies()
        }
        tableView.reloadData()
    }
    
    func initialization() {
        segmentControl.tintColor = greenTheme
    }
    
    func getAllActivePolicies() {
        let dictionary: [String : String] = ["contractType": ContractType.product.rawValue, "operation": Operation.getAllActivePolicies.rawValue , "jsonObject": farmerKey ?? "","pwd":password!]
        activityIndicatorBegin()
        apicall.getAllActivePolicies(parameter: dictionary) { (policies, error) in
            if policies != nil  && policies != nil {
                self.activePoliciesArray = policies!
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: errorMessage)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicatorEnd()
                if self.activePoliciesArray.count == 0 {
                    self.showAlert(message: NSLocalizedString("No policies found", comment: ""))
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func getAllHoldingPolicies() {
        let dictionary: [String : String] = ["contractType": ContractType.policy.rawValue, "operation": Operation.getHoldingPolicies.rawValue , "jsonObject": farmerKey ?? "", "farmerId": String(farmerid ?? "0"),"pwd": password!,"subOperation": Operation.subOperationForHolding.rawValue]
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
    
    //MARK: table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isBuyPolicySelected {
            return activePoliciesArray.count
        }
        return holdingPoliciesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PolicyCell = tableView.dequeueReusableCell(withIdentifier: "PolicyCell", for: indexPath) as! PolicyCell
        if isBuyPolicySelected {
            cell.configureCellForBuy(policiy: activePoliciesArray[indexPath.row])
        } else {
            cell.configureCellForHolding(policiy: holdingPoliciesArray[indexPath.row])
        }
        cell.buyPolicyButton.tag = indexPath.row
        cell.buyPolicyButton.addTarget(self, action: #selector(navigateToBuyOrClaim(button:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 417
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @objc func navigateToBuyOrClaim(button: UIButton) {
        if isBuyPolicySelected {
            guard let buyPolicies: BuyPolicyViewController = storyboard?.instantiateViewController(withIdentifier: "BuyPolicyViewController") as? BuyPolicyViewController else { return  }
            if activePoliciesArray.count > button.tag {
                buyPolicies.policy = activePoliciesArray[button.tag]
            }
            self.navigationController?.pushViewController(buyPolicies, animated: true)
        } else {
            guard let buyPolicies: ManualClaimViewController = storyboard?.instantiateViewController(withIdentifier: "ManualClaimViewController") as? ManualClaimViewController else { return  }
            if holdingPoliciesArray.count > button.tag {
                buyPolicies.policy = holdingPoliciesArray[button.tag]
            }
            self.navigationController?.pushViewController(buyPolicies, animated: true)
        }
    }
}
