//
//  ValidateFields.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 18/07/24.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func isValidContact(_ contact: String) -> Bool {
    let CONTACT_REGEX = "^[6-9]\\d{9}$"
    let contactTest = NSPredicate(format: "SELF MATCHES %@", CONTACT_REGEX)
    return contactTest.evaluate(with: contact)
}

func isValidPassword(_ password: String) -> Bool {
    let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: password)
}
