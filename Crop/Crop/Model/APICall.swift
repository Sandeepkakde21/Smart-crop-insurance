//
//  APICall.swift
//  Roadcruza
//
//  Created by Sandeep Kakde on 20/10/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import Foundation
public typealias CompletionHandler = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()
enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

enum ContractType: String {
    case farmer = "Farmer"
    case policy = "Policy"
    case product = "Product"
}

enum Operation: String {
    case addFarmerDetails = "registerFarmer"
    case login = "loginFarmer"
    case buyPolicy = "buyPolicy"
    case getAllActivePolicies = "getAllActiveProducts"
    case getHoldingPolicies = "getALLFarmerPolicies"
    case manualClaim =  "processManualClaim"
    case subOperationForHolding = "holdingPolicesDetail"
    case subOperationForHClaimHistory = "settledPolicesDetail"

}

class APICall {
//    var baseUrl =  "http://104.215.193.184:8080/contractFunction"
    var baseUrl =  "http://137.116.168.105:8080/contractFunction"
    let loginUrl = "http://137.116.168.105:8080/login"

    var imagebaseUrl = ""
    
    private var task: URLSessionTask?
    
    
    func getImageData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let finalURL = imagebaseUrl + url
        guard let apiUrl = URL(string: finalURL) else {
            return
        }
        URLSession.shared.dataTask(with: apiUrl, completionHandler: completion).resume()
    }
    
    private func request(_ url: String, method: String, parameter: Dictionary<String, Any>?, completion: @escaping CompletionHandler) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 1000.0
        //sessionConfig.timeoutIntervalForResource = 10000.0
        let session = URLSession(configuration: sessionConfig)
        do {
            guard let apiUrl = URL(string: url) else {
                return
            }
            var request = try self.buildRequest(from: apiUrl, method: method, parameter: parameter)
            request.timeoutInterval = 100.0
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from url: URL, method: String, parameter: Dictionary<String, Any>?) throws -> URLRequest {
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = method
        if parameter != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let argumentDictionary =  ["arguments": parameter!]
            let jsonData = try? JSONSerialization.data(withJSONObject: argumentDictionary, options: .prettyPrinted)
            
            request.httpBody = jsonData
        }
        return request
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func registerFarmer(parameter: Dictionary<String, String>?, completion: @escaping (_ Series: RegistrationResponse?,_ error: String?)->()) {
        let url = baseUrl
        self.request(url, method: "POST", parameter: parameter) { (data, respone, error) in
            if error != nil {
                completion(nil,error?.localizedDescription )
            }
            if let response = respone as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        //                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(RegistrationResponse.self, from: responseData)
                        completion(apiResponse,apiResponse.message)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getAllActivePolicies(parameter: Dictionary<String, String>?, completion: @escaping (_ Series: [Policies]?,_ error: String?)->()) {
        let url = baseUrl
        self.request(url, method: "POST", parameter: parameter) { (data, respone, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = respone as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(Array<Policies>.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getAllHoldingPolicies(parameter: Dictionary<String, String>?, completion: @escaping (_ Series: [HoldingPolicies]?,_ error: String?)->()) {
        let url = baseUrl
        self.request(url, method: "POST", parameter: parameter) { (data, respone, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = respone as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(Array<HoldingPolicies>.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func loginFarmer(parameter: Dictionary<String, String>?, completion: @escaping (_ Series: loginResponse?,_ error: String?)->()) {
        self.request(loginUrl, method: "POST", parameter: parameter) { (data, respone, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = respone as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        //                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        let apiResponse = try JSONDecoder().decode(Array<loginResponse>.self, from: responseData)
                        completion(apiResponse.first,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func buyAndClaimPolicy(parameter: Dictionary<String, Any>?, completion: @escaping (_ Series: BuyPolicyResponse?,_ error: String?)->()) {
        let url = baseUrl
        self.request(url, method: "POST", parameter: parameter) { (data, respone, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = respone as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        //                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        let apiResponse = try JSONDecoder().decode(Array<BuyPolicyResponse>.self, from: responseData)
                        completion(apiResponse.first,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
}
