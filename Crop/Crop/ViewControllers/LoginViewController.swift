//
//  LoginViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 03/11/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var mobileUmberTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var mobileNumber: String!
    var password: String!
    override func viewDidLoad() {
        ControllerTitle =  NSLocalizedString("Login", comment: "")
        super.viewDidLoad()
        loginButton.backgroundColor = greenTheme
        mobileUmberTextField.borderAndRoundedCorner()
        passwordTextField.borderAndRoundedCorner()
        let aadhar = getDataFromUserDefault(key: FarmerData.aadharNumber.rawValue)
        let password = getDataFromUserDefault(key: FarmerData.passWord.rawValue)
        mobileUmberTextField.text = aadhar
        passwordTextField.text = password
    }
    
    @IBAction func loginActionButton(_ sender: UIButton) {
        mobileNumber =  mobileUmberTextField.text?.trimmingCharacters(in: .whitespaces)
        password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        if (!mobileNumber.isEmpty || mobileNumber.count != 0) && (!password.isEmpty || password.count != 0) {
            activityIndicatorBegin()
            let dictionary = ["contractType": ContractType.farmer.rawValue,"fUserId": mobileNumber, "fPassword": password] as! [String : String]
            apicall.loginFarmer(parameter: dictionary) { (response, error) in
                if response?.Status ?? false == true{
                    DispatchQueue.main.async {
                        self.activityIndicatorEnd()
                        guard let policyVC = self.storyboard?.instantiateViewController(withIdentifier: "PoliciesViewController") else { return  }
                        self.navigationController?.pushViewController(policyVC, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicatorEnd()
                        self.showAlert(message: NSLocalizedString("Login failed please try again", comment: ""))
                    }
                }
            }
            
        } else {
            showAlert(message: NSLocalizedString("Please enter Aadhar number and password", comment: ""))
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
