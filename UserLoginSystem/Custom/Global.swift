//
//  Global.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 03/09/24.
//

import Foundation
import SwiftUI

struct Global {
    static let AppName = "User Login System"
    
    static let BASE_URL = "http://127.0.0.1:8000/api/"
    
    static let userPayload = "user_payload"
    static let userLogin = "user_login"
    
    static let LOGIN = BASE_URL + "login"
    static let SIGN_UP = BASE_URL + "sign_up"
    static let HOME = BASE_URL + "home"
    
    static let ADD_ADDRESS = BASE_URL + "add_delivery_address"
    static let UPDATE_ADDRESS = BASE_URL + "update_delivery_address"
    static let REMOVE_ADDRESS = BASE_URL + "delete_delivery_address"
    static let ADDRESS_LIST = BASE_URL + "delivery_address"
}

struct APIResponse {
    static let status = "status"
    static let message = "message"
    static let payload = "payload"
}

class Utils {
    class func UDSET(data: Any, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func UDValue( key: String) -> Any {
       return UserDefaults.standard.value(forKey: key) as Any
    }
    
    class func UDValueFalseBool( key: String) -> Bool {
       return UserDefaults.standard.value(forKey: key) as? Bool ?? false
    }
    
    class func UDValueTrueBool( key: String) -> Bool {
       return UserDefaults.standard.value(forKey: key) as? Bool ?? true
    }
    
    class func UDRemove( key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
