//
//  TextFieldViewModel- Validation.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 9.12.23.
//

import Foundation

extension TextFieldViewModel {
    
    func validate(text: String) {
        switch validationType {
        case .none:
            return
        case .general:
            self.textFieldError = generalValidation(text: text)
        case .email:
            self.textFieldError = emailValidation(text: text)
        case .password:
            self.textFieldError = passwordValidation(text: text)
        case .confirmPassword(let mainPassword, let errMessage):
            self.textFieldError = confirmTextToCompareValidation(text: text, compareTo: mainPassword, errMessage: errMessage)
        }
    }
    
    func generalValidation(text: String) -> (Bool, String) {
        text.count > 0 ? (false, "") : (true, "Field must not be empty")
    }
    
    func emailValidation(text: String) -> (Bool, String) {
        let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: text) {
            return (true, "Email is not valid")
        }
        
        return (false, "")
    }
    
    func passwordValidation(text: String) -> (Bool, String) {
        if text.count < 6 {
            return (true, "Password must be at least 6 characters")
        }
        
        if !matchesPattern(text, pattern: "(?=.*[A-Z])") {
            return (true, "Provide at least one uppercase letter")
        }
        
        if !matchesPattern(text, pattern: "(?=.*[!@#$&*])") {
            return (true, "Provide at least one special character")
        }
        
        return (false, "")
    }
    
    func confirmTextToCompareValidation(text: String, compareTo textToCompare: String?, errMessage: String?) -> (Bool, String) {
        if let textToCompare {
            if text == textToCompare {
                return (false, "")
            } else {
                return (true, errMessage ?? "Values must be the same!")
            }
        } else {
            return (true, "There is no password field available")
        }
    }
    
    private func matchesPattern(_ string: String, pattern: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: string.utf8.count)
        return regex.firstMatch(in: string, range: range) != nil
    }
}
