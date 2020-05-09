//
//  GenericViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 03/11/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit
import CoreLocation


class BaseViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var greyView: UIView!
    var locManager: CLLocationManager!
    var currentLocation: CLLocation!
    private var _title: String = NSLocalizedString("Crop Insurance", comment: "")
    
    var ControllerTitle: String {
        set { _title = newValue }
        get { return _title }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genericInitialization()
        hideNavigationBackButton()
        setNavigationBackButtonTitle()
        
    }
    
    func genericInitialization() {
        title = _title
    }
    
    func setNavigationBackButtonTitle(title: String = " ") {
        let item = UIBarButtonItem(title:title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = item
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    func hideNavigationBackButton(value: Bool = false) {
        navigationItem.setHidesBackButton(value, animated: true)
    }
    
    
    func setFarmerProfile() {
        let item = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(rightButtonAction(sender:)))
        navigationItem.rightBarButtonItem = item
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        guard let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") else { return  }
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    func showAlert(message: String?) {
        let alert = UIAlertController(title: NSLocalizedString("Crop Insurance", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithBackAction(vc: UIViewController, message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Crop Insurance", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { action in
            DispatchQueue.main.async {
                vc.navigationController?.popViewController(animated: true)
            }
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func activityIndicatorBegin() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        //activityIndicator.center = self.view.center
        activityIndicator.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = greenTheme
        activityIndicator.layer.cornerRadius = 15.0
        activityIndicator.layer.masksToBounds = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        greyView = UIView()
        greyView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        greyView.backgroundColor = .black
        greyView.alpha = 0.6
        self.view.addSubview(greyView)
    }
    
    func activityIndicatorEnd() {
        self.activityIndicator.stopAnimating()
        self.greyView.removeFromSuperview()
    }
    
    //MARK: Location
    public func startLocation () {
        locManager = CLLocationManager()
        locManager.desiredAccuracy = kCLLocationAccuracyKilometer
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if CLLocationManager.locationServicesEnabled() {
                currentLocation = locManager.location
                print(currentLocation.coordinate.latitude)
                print(currentLocation.coordinate.longitude)
            }
        default:
            locManager.requestWhenInUseAuthorization()
        }
    }
}
