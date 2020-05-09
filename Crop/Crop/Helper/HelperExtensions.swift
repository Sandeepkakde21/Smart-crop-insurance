//
//  HelperExtensions.swift
//  Roadcruza
//
//  Created by Sandeep Kakde on 19/10/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import Foundation
import UIKit

let apicall = APICall()
let errorMessage =  NSLocalizedString("Something went wrong, Please check your network connection", comment: "")
public enum FarmerData: String {
    case farmerName = "userName"
    case farmerkey = "key"
    case mobileNumber = "mobile"
    case passWord = "password"
    case aadharNumber = "aadhar"
    case email = "email"
}

let greenTheme = UIColor.init(red: 0.0/255, green: 78.0/255, blue: 0.0/255, alpha: 1)
//MARK: UIButton
extension UIButton {
    func border(width: CGFloat = 1) {
        self.backgroundColor = .clear
        self.layer.borderWidth = width
        self.layer.borderColor = greenTheme.cgColor
    }
    
    func roundedCorner(size: CGFloat = 5) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = size
    }
}


extension UIView {
    
    func borderAndCornerRadius(borderWidth: CGFloat = 1, radius: CGFloat = 5) {
        self.backgroundColor = .white
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func shadow() {
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        //layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 1.0
}
}

extension UILabel {
    func roundedCorner(size: CGFloat = 5) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = size
    }
}

extension UITextField {
    
    func borderAndRoundedCorner() {
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = greenTheme.cgColor
        
    }
}

func storeDataInUserDefault(key: String, value: String) {
    UserDefaults.standard.set(value, forKey: key)
}

func getDataFromUserDefault(key: String) -> String? {
    return   UserDefaults.standard.string(forKey: key)
    
}

func isValidEmail(emailStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: emailStr)
}
