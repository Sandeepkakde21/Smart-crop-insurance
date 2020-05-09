//
//  BuyPolicyViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/07.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

public enum SelectedButton {
    case selectYear
    case selectSeason
    case selectState
    case selectDist
    case selectCrop
    case selectScheme
}

class BuyPolicyViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var schemeButton: UIButton!
    @IBOutlet weak var districtButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var seasonButton: UIButton!
    var policy: Policies!
    var selectedButton: SelectedButton!
    var toolBar = UIToolbar()
    var picker: UIPickerView!
    var year: String = ""
    var season: String = ""
    var state: String = ""
    var dist: String = ""
    var crop: String = ""
    var scheme: String = ""
    var hector: String = "0"
    var amount: String = "0"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        ControllerTitle = NSLocalizedString("Buy Policy", comment: "")
        super.viewDidLoad()
        initalization()
        startLocation()
    }
    
    func initalization() {
        yearButton.roundedCorner()
        yearButton.border()
        schemeButton.roundedCorner()
        schemeButton.border()
        districtButton.roundedCorner()
        districtButton.border()
        buyButton.backgroundColor = greenTheme
        buyButton.roundedCorner()
        amountButton.roundedCorner()
        amountButton.border()
        cropButton.roundedCorner()
        cropButton.border()
        stateButton.roundedCorner()
        stateButton.border()
        seasonButton.roundedCorner()
        seasonButton.border()
        areaTextField.borderAndRoundedCorner()
    }
    
    //    {
    //    "arguments": {
    //    "jsonObject": "{\"version\":3,\"id\":\"949e0f4a-062d-460b-bca3-ebc0017257a3\",\"address\":\"588ba02a61cc447769423694357f8c832db0f01a\",\"crypto\":{\"ciphertext\":\"5b20a199ec94b28e823756077e8f5fd6ce51a5a4468d0b004cb60923fa9a3e03\",\"cipherparams\":{\"iv\":\"b7aa2360c559e819561eccb774c94664\"},\"cipher\":\"aes-128-ctr\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"salt\":\"6d9e18d99781aa95e76a3ac87a2744d951cdec7e6a2fb52bc8e24cd6be808e62\",\"n\":262144,\"r\":8,\"p\":1},\"mac\":\"84be170513c2371cc41e36e5f8934f7ad1b99e4268fef9fe030fb3373e92591e\"}}",
    //    "pwd": "10",
    //    "contractType": "Policy",
    //    "operation": "buyPolicy",
    //    "farmerId": "123",
    //    "productId": 101,
    //    "insurenceProvider": "ICICI",
    //    "sessionType": "2019",
    //    "expiryDate": "2020",
    //    "premium": 500,
    //    "forCrop": "Cotton",
    //    "areaInHector": 3,
    //    "insuredAmount": 50000,
    //    "latitude": "latitude",
    //    "longitude": "langitude",
    //    "state": "Maharashtra",
    //    "district": "Pune"
    //    }
    //    }
    
    
    
    func validation() -> Bool {
        if  hector.isEmpty || hector.count == 0 {
            showAlert(message: NSLocalizedString("Area in hector is compulsory.", comment: ""))
            return false
        }
        return true
    }
    
    
    // {
    //    "arguments": {
    //    "jsonObject": "{\"version\":3,\"id\":\"0a980a43-0287-4f1f-861e-cc707adb0f8f\",\"address\":\"20d07df48bd5666d707474f3f524c165d8b142d2\",\"crypto\":{\"ciphertext\":\"826ef978985443be1c73d1deafb6f6204be7e2ffc69978d6c9b2b23439779924\",\"cipherparams\":{\"iv\":\"445e3c17eb115695f39d5c6b4427696e\"},\"cipher\":\"aes-128-ctr\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"salt\":\"c0413bddded7f8a3baa91a898efd5fe442c1f2eb8bec52f7a513078e24cb1ed4\",\"n\":262144,\"r\":8,\"p\":1},\"mac\":\"5d87fdaae318b3c17211bd7c93d5f0ab1dd26b929062b544925d7a4c9796d484\"}}",
    //    "pwd": "Jadhav@33",
    //    "contractType": "Policy",
    //    "operation": "buyPolicy",
    //    "farmerId": "12",
    //    "productId": 5001,
    //    "premium": 1000,
    //    "areaInHector": 3,
    //    "latitude": "54.0987",
    //    "longitude": "65.7877"
    //    }
    //    }
    @IBAction func buyPoliciesAction(_ sender: UIButton) {
        self.view.endEditing(true)
        startLocation()
        if currentLocation == nil {
            showAlert(message: NSLocalizedString("Please allow location service enable", comment: ""))
            startLocation()
            return
        }
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        if latitude == 0.0 && longitude == 0.0 {
            showAlert(message: NSLocalizedString("Please allow location service enable", comment: ""))
            startLocation()
            return
        }
        let farmerKey = getDataFromUserDefault(key: FarmerData.farmerkey.rawValue)
        let farmerid = getDataFromUserDefault(key: FarmerData.aadharNumber.rawValue)
        let password = getDataFromUserDefault(key: FarmerData.passWord.rawValue)
        
        let dictionary = ["contractType": ContractType.policy.rawValue, "operation": Operation.buyPolicy.rawValue, "jsonObject": farmerKey ?? "", "farmerId": String(farmerid ?? "0"), "productId": policy.productId!, "premium": Int(policy.premiumAmountPerHector!) ?? 0, "areaInHector": Int(hector), "latitude": latitude,"longitude":longitude,"pwd": password!] as! [String : Any]
        activityIndicatorBegin()
        if validation() {
            apicall.buyAndClaimPolicy(parameter: dictionary) { (response, error)  in
                DispatchQueue.main.async {
                    self.activityIndicatorEnd()
                    if response?.status == 200 {
                        self.showAlertWithBackAction(vc: self, message: NSLocalizedString("Buy policy completed.", comment: ""))
                    } else {
                        self.showAlert(message: NSLocalizedString("Buy policy failed", comment: ""))
                        
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField ==  areaTextField {
            let text = areaTextField.text
            let total = Int(text ?? "0")! * Int(policy.premiumAmountPerHector!)!
            let message:String =  NSLocalizedString("Total payable ", comment: "") + String(total)
            hector = areaTextField.text ?? "0"
            amountButton.setTitle(message, for: .normal)
        }
        return true
    }
    
    func addPicker() {
        if picker != nil {
            onDoneButtonTapped()//existing picker open
        }
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        toolBar = UIToolbar(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .black
        toolBar.backgroundColor = greenTheme
        toolBar.items = [UIBarButtonItem(title:  NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(onDoneButtonTapped))]
        toolBar.tintColor = .white
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    //MARK: picker delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedButton {
        case .selectYear?:
            return 1
        case .selectSeason?:
            return 1
        case .selectState?:
            return 1
        case .selectCrop?:
            return 1
        case .selectScheme?:
            return 1
        case .selectDist?:
            return 1
            
        case .none:
            return  0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedButton {
        case .selectYear?:
            let yearValue = "2020"
            year = yearValue
            yearButton.setTitle(yearValue, for: .normal)
            return yearValue
        case .selectSeason? :
            let seasonValue = "Kharif"
            season = seasonValue
            seasonButton.setTitle(seasonValue, for: .normal)
            return seasonValue
        case .selectState? :
            let stateValue = "Maharashtra"
            state = stateValue
            stateButton.setTitle(stateValue, for: .normal)
            return stateValue
        case .selectCrop? :
            let cropValue = "Cotton"
            crop = cropValue
            cropButton.setTitle(cropValue, for: .normal)
            return cropValue
        case .selectScheme?:
            let schemeValue = "Cotton crop Insurance"
            scheme = schemeValue
            schemeButton.setTitle(schemeValue, for: .normal)
            return schemeValue
        case .selectDist?:
            let distValue = "Aurangabad"
            dist = distValue
            districtButton.setTitle(distValue, for: .normal)
            return distValue
        case .none:
            return "Not found"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.view.endEditing(true)
    }
    
    //MARK: All actions
    
    @IBAction func selectSeasonAction(_ sender: UIButton) {
        selectedButton = SelectedButton.selectSeason
        addPicker()
    }
    
    @IBAction func selectYearAction(_ sender: UIButton) {
        selectedButton = SelectedButton.selectYear
        addPicker()
        
    }
    
    @IBAction func selectSchemeAction(_ sender: UIButton) {
        selectedButton = SelectedButton.selectScheme
        addPicker()
        
    }
    
    @IBAction func selectDistrictAction(_ sender: UIButton) {
        selectedButton = SelectedButton.selectDist
        addPicker()
        
    }
    
    @IBAction func selectCropAction(_ sender: UIButton) {
        selectedButton = SelectedButton.selectCrop
        addPicker()
    }
    @IBAction func selectStateAction(_ sender: UIButton) {
        selectedButton = SelectedButton.selectState
        addPicker()
    }
}
