//
//  ForgotPasswordMainView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 11.12.23.
//

import SwiftUI
import RealmSwift
import iOS_Backend_SDK

struct ForgotPasswordMainView: View {
    
    let token: String
    
    @State private var isLoading: Bool = false
    
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var validations: [Bool] = Array(repeating: false, count: 2)
    
    var body: some View {
        VStack(spacing: 30) {
            BeforeAuthHeadingView(icon: "lock.rotation", heading: "Restore your password", mainHeadingWord: "", subheadline: "Write your new password")
            
            VStack(spacing: 15) {
                DefaultTextField(text: $newPassword, icon: "key.horizontal.fill", placeholder: "New password", validation: $validations[0])
                    .validationType(.password)
                
                DefaultTextField(text: $confirmNewPassword, icon: "key.horizontal.fill", placeholder: "New password", validation: $validations[1])
                    .validationType(.confirmPassword, mainPassword: newPassword)
            }
            
            DefaultButton(
                text: "Restore password",
                isDisabled: validations != Array(repeating: true, count: 2),
                isLoading: self.isLoading
            ) {
                Task {
                    await restorePassword()
                }
            }
            Spacer()
        }
        .padding()
        .padding(.top)
    }
    
    func restorePassword() async {
        self.isLoading = true
        await Backend.shared.resetPassword(token: self.token, email: OpenURL.main.email, password: self.newPassword, confirmPassword: self.confirmNewPassword) { result in
            switch result {
            case .success(let response):
                if let backendUser = response.data?.user {
                    let user = User(_id: try! ObjectId(string: backendUser._id), token: response.token, name: backendUser.name, email: backendUser.email, photo: backendUser.photo)
                    
                    DB.shared.save(user, shouldBeOnlyOne: true, ofType: User.self)
                    Navigator.main.navigate(to: .forgotPasswordSuccessfullyChanged, path: .beforeAuth)
                }
            case .failure(let error):
                Components.shared.showMessage(type: .error, text: error.localizedDescription)
            }
            OpenURL.main.email = ""
        }
        self.isLoading = false
    }
}

#Preview {
    ForgotPasswordMainView(token: "")
}
