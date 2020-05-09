//
//  ManualClaimViewController.swift
//  Crop
//
//  Created by Sandeep Kakde on 2019/11/10.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ManualClaimViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var percentageDamageLabel: UILabel!
    @IBOutlet weak var manuaClaimButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    var policy: HoldingPolicies!
    var percentageClaim: String = ""
    
    var imagePicker = UIImagePickerController()
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */ //FlowerClassifier
            let model = try VNCoreMLModel(for: Cotton().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            // request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        ControllerTitle = NSLocalizedString("Manual Claime", comment: "")
        super.viewDidLoad()
        initialization()
        
    }
    
    func initialization() {
        percentageDamageLabel.text = NSLocalizedString("Percentrage damage = ?", comment: "")
        manuaClaimButton.backgroundColor = greenTheme
        manuaClaimButton.roundedCorner()
        selectImageButton.backgroundColor = greenTheme
        selectImageButton.roundedCorner()
    }
    
    @IBAction func selectImageAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView.image = image
            updateClassifications(for: image)
        }
        imagePicker.dismiss(animated: true, completion: nil);
    }
    
    func updateClassifications(for image: UIImage) {
        percentageDamageLabel.text = NSLocalizedString("Please wait we are in process...", comment: "")
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else { return  }
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.showAlert(message: "Unable to classify image please retake  new image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.showAlert(message: NSLocalizedString("Please retake new image as we are not able to process with this image", comment: ""))
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(1)
                let descriptions = topClassifications.map { classification -> String in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    
                    //return String (format: "%@ Percent cotton damage",  classification.identifier )
                    print(classification.confidence)
                    
                    if classification.confidence > 0.60 {
                        self.percentageClaim = classification.identifier
                        //                        return String(format: " Image processed confidance (%.2f)  Damage cotton percentage is%@", classification.confidence, classification.identifier)
                        let textPartOne = NSLocalizedString("You will get", comment: "")
                        let textPartTwo = NSLocalizedString("percent insurance amount", comment: "")

                        return String(format: textPartOne + " %@ " + textPartTwo,classification.identifier)
                        
                    } else {
                        self.showAlert(message: NSLocalizedString("Image not processed please select new image captured in good lights", comment: ""))
                        return "Image not processed"
                    }
                }
                self.percentageDamageLabel.text =  descriptions.joined(separator: "\n")
            }
        }
    }
    
    
    @IBAction func submitbuttonClicked(_ sender: UIButton) {
        if percentageClaim == "" || percentageClaim.count == 0 {
            showAlert(message: NSLocalizedString("Select another good quality image and try again", comment: ""))
            return
        }
        activityIndicatorBegin()
        let farmerKey = getDataFromUserDefault(key: FarmerData.farmerkey.rawValue)
        let farmerid = getDataFromUserDefault(key: FarmerData.aadharNumber.rawValue)
        let password = getDataFromUserDefault(key: FarmerData.passWord.rawValue)
        let email = getDataFromUserDefault(key: FarmerData.email.rawValue)

        let dictionary = ["contractType": ContractType.policy.rawValue, "operation": Operation.manualClaim.rawValue, "jsonObject": farmerKey ?? "", "farmerId": String(farmerid ?? "0"), "policyId": Int(policy.policyId!),"percentage": Int(percentageClaim),"pwd": password, "email": email!] as! [String : Any]
        apicall.buyAndClaimPolicy(parameter: dictionary) { (response, error) in
            DispatchQueue.main.async {
                self.activityIndicatorEnd()
                if response?.status == 200 {
                    self.showAlertWithBackAction(vc: self, message: NSLocalizedString("Claim recorded successfully", comment: ""))
                } else {
                    self.showAlertWithBackAction(vc: self, message: NSLocalizedString("Claim not recorded", comment: ""))
                    
                }
            }
        }
    }
    
}
