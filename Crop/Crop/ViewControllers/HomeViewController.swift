//
//  ViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 03/11/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    func initializeUI() {
        registerButton.roundedCorner()
        loginButton.roundedCorner()
        guestButton.roundedCorner()
        registerButton.backgroundColor = greenTheme
        loginButton.backgroundColor = greenTheme
        guestButton.backgroundColor = greenTheme
    }
    
    @IBAction func guestButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else { return  }
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    @IBAction func registerButtonAction(_ sender: UIButton) {
        guard let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") else { return  }
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
}

