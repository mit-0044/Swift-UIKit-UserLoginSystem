//
//  UserModel.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 04/09/24.
//

import Foundation
struct Users: Codable {
    let id: Int
    let name: String
    let role: String
    let email: String
    let contact: String
    let address: String
}
