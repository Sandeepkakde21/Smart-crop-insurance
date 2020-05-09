//
//  AllModel.swift
//  Roadcruza
//
//  Created by Sandeep Kakde on 20/10/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import Foundation

struct Policies: Decodable {
    let productId: String?
    let productName: String?
    let insuranceProvider: String?
    let forCrop: String?
    let premiumAmountPerHector: String?
    let insuredAmount: String?
    let productDocHash: String?
    let expiryDate: String?
    let isActive: Bool?
}

struct HoldingPolicies: Codable {
    let policyId: String?
    let productId: String?
    let farmerId: String?
    let startDate: String?
    let expiryDate: String?
    let status: String?
    let areaInHector: String?
    let totalPremium: String?
    let insuredAmount: String?
    let settlementPaidAmount: String?
    let settlementPaidDate: String?
    let latitude: String?
    let longitude: String?
    let insuranceProvider: String?
    let forCrop: String?
    let claimType: Bool?

}

struct genericResponse: Decodable {
    let Status: Int?
}

struct loginResponse: Decodable {
    let Status: Bool?
    
}

struct RegistrationResponse: Decodable {
    let status: Int?
    let transactionHash: String?
    let message: String?
    let encryptedObject: String?
    let success: String?
}

struct BuyPolicyResponse: Decodable {
    let status: Int?
    let transactionHash: String?
    let message: String?
}
