//
//  UserModel.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 06/08/24.
//

import Foundation

struct Users: Codable {
    let id: Int
    let name: String
    let type: String
    let email: String
    let contact: String
    let address: String
}
