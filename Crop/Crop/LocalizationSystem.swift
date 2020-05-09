//
//  LocalizationSystem.swift
//  Crop
//
//  Created by Sandeep Kakde on 20/12/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import Foundation
import UIKit

var bundleKey: UInt8 = 0
class LocalizationSystem: Bundle {
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
                
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, LocalizationSystem.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
