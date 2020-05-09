//
//  LanguageSelectionViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 20/12/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: BaseViewController {
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var hindiButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var marathiButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        hindiButton.roundedCorner()
        hindiButton.backgroundColor = greenTheme
        englishButton.roundedCorner()
        englishButton.backgroundColor = greenTheme
        selectButton.roundedCorner()
        selectButton.backgroundColor = greenTheme
        marathiButton.roundedCorner()
        marathiButton.backgroundColor = greenTheme
    }
    
    @IBAction func continueInEnglishAction(_ sender: UIButton) {
        Bundle.setLanguage("en")
        navigateToRegister()
    }
    

    @IBAction func ContinueInHindiAction(_ sender: UIButton) {
        Bundle.setLanguage("hi")
        navigateToRegister()
    }
    @IBAction func continueWithMarathiAction(_ sender: UIButton) {
        Bundle.setLanguage("mr-IN")
        navigateToRegister()

    }
    
    func navigateToRegister() {
        guard let policyVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") else { return  }
        self.navigationController?.pushViewController(policyVC, animated: true)
    }
}
