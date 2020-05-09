//
//  RegisterViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 03/11/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var aadharTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    var email: String!
    var mobileNumber: String!
    var fullName: String!
    var aadhar: String!
    var password: String!
    var confirmPassword: String!
    
    override func viewDidLoad() {
        ControllerTitle = NSLocalizedString("Registration", comment: "") //"Registration"
        super.viewDidLoad()
        initialization()
    }
    
    func initialization() {
        mobileNumberTextField.borderAndRoundedCorner()
        emailTextfield.borderAndRoundedCorner()
        passwordTextField.borderAndRoundedCorner()
        fullNameTextField.borderAndRoundedCorner()
        aadharTextField.borderAndRoundedCorner()
        
        confirmPasswordTextField.borderAndRoundedCorner()
        submitButton.roundedCorner()
        submitButton.backgroundColor = greenTheme
        ControllerTitle = NSLocalizedString("Registration", comment: "")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func registerFarmerAction(_ sender: UIButton) {
        if validation() {
            let dictionary: [String : String] = ["contractType": ContractType.farmer.rawValue, "operation": Operation.addFarmerDetails.rawValue, "fName": fullName,"fMobile": mobileNumber, "fEmail": email, "pwd": password, "fUserId": aadhar]
            activityIndicatorBegin()
            apicall.registerFarmer(parameter: dictionary) { (response, error) in
                if response?.status == 200 {
                    self.saveFarmerDetail(key: response!.encryptedObject!)
                    DispatchQueue.main.async {
                        self.navigateToBase()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: error)
                    }
                }
                
                DispatchQueue.main.async {
                    self.activityIndicatorEnd()
                    //navigate to login
                }
            }
            
        } else {
            
            showAlert(message: NSLocalizedString("Please check all fields", comment: ""))
            //showAlert(message: "Please check all fields")
        }
    }
    
    func navigateToBase() {
        guard let policyVC = storyboard?.instantiateViewController(withIdentifier: "PoliciesViewController") else { return  }
        self.navigationController?.pushViewController(policyVC, animated: true)
    }
    
    func saveFarmerDetail(key: String) {
        storeDataInUserDefault(key: FarmerData.aadharNumber.rawValue, value: aadhar)
        storeDataInUserDefault(key: FarmerData.farmerName.rawValue, value: fullName)
        storeDataInUserDefault(key: FarmerData.farmerkey.rawValue, value: key)
        storeDataInUserDefault(key: FarmerData.mobileNumber.rawValue, value: mobileNumber)
        storeDataInUserDefault(key: FarmerData.passWord.rawValue, value: password)
        storeDataInUserDefault(key: FarmerData.email.rawValue, value: email)
    }
    
    func validation() -> Bool {
        mobileNumber =  mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces)
        fullName = fullNameTextField.text?.trimmingCharacters(in: .whitespaces)
        password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespaces)
        aadhar = aadharTextField.text?.trimmingCharacters(in: .whitespaces)
        email = emailTextfield.text?.trimmingCharacters(in: .whitespaces)

        
        if mobileNumber.isEmpty || mobileNumber.count == 0 || fullName.isEmpty || fullName.count == 0 || password.isEmpty || password.count == 0 || confirmPassword.isEmpty || confirmPassword.count == 0 || aadhar.isEmpty || aadhar.count == 0 || email.isEmpty || email.count == 0 {
        
//            let msg = NSLocalizedString("All fields are compulsory and text length should be more than one character in it", comment: "")
            let msg = NSLocalizedString("All fields are compulsory and text length should be more than one character in it",comment: "")
            showAlert(message: msg)
            return false
        }
        
        if password != confirmPassword {
            showAlert(message: NSLocalizedString("Password and confirm-password must be same", comment: ""))
            return false
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
