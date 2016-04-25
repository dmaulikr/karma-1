//
//  DataStorage.swift
//  Karma
//
//  Created by Ankur Mahesh on 4/24/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit

class DataStorage: NSObject {

    static var doubleDictionary:[String: Double] = ["radius":200.0]
//    static var booleanDictionary:[String: Bool] = ["userHasPutInRadius":false]
    
    static func storeDouble(key: String, myDouble: Double) {
        
        doubleDictionary[key] = myDouble
    }
    static func getDouble(key: String) -> Double {
        return doubleDictionary[key]!
    }
    
//    static func storeBoolean(key: String, boolToStore: Bool) {
//        booleanDictionary[key] = boolToStore
//    }
//    
//    static func getBoolean(key: String) -> Bool {
//        return booleanDictionary[key]!
//    }
}
