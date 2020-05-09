//
//  ProfileViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/07.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        ControllerTitle = NSLocalizedString("Profile", comment: "")
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.logOutButton.addTarget(self, action: #selector(navigateToBuyOrClaim(button:)), for: .touchUpInside)
        cell.claimHistory.addTarget(self, action: #selector(navigateToClaimHistory(button:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    @objc func navigateToBuyOrClaim(button: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func navigateToClaimHistory(button: UIButton) {
        guard let buyPolicies: ClaimeHistoryViewController = storyboard?.instantiateViewController(withIdentifier: "ClaimeHistoryViewController") as? ClaimeHistoryViewController else { return  }
        self.navigationController?.pushViewController(buyPolicies, animated: true)

    }
}
