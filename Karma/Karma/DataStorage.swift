//
//  DataStorage.swift
//  Karma
//
//  Created by Ankur Mahesh on 4/24/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit

class DataStorage: NSObject {

    static var doubleDictionary[String: Double] = [:]
    
    static func storeDouble(key: String, myDouble: Double) {
        doubleDictionary[key] = myDouble
    }
    static func getDouble(key: String) -> Double {
        return doubleDictionary[key]
    }
}
