//
//  TextFieldValidationType.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 9.12.23.
//

import Foundation

enum TextFieldValidationType: Codable, Equatable {
    case none
    case general
    case email
    case password
    case confirmPassword(mainPassword: String, errorMessage: String)
}
