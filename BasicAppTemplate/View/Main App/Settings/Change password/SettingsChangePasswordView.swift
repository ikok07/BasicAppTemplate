//
//  SettingsChangePasswordView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 19.12.23.
//

import SwiftUI

struct SettingsChangePasswordView: View {
    
    @Bindable var viewModel = ViewModel()
    
    var body: some View {
        List {
            
            ListProgressView(isActive: viewModel.isLoading)
            
            Section("") {
                ListInputField(icon: "lock", label: nil, placeholder: "Your password", resetter: $viewModel.resetTextFields, text: $viewModel.currentPassword, validation: $viewModel.validation[0])
                    .labelWidthSize(5)
                    .customIcon(font: .title3)
                    .validationType(.general)
                    .isSecure()
                
                ListInputField(icon: "key.horizontal", label: nil, placeholder: "New password", resetter: $viewModel.resetTextFields, text: $viewModel.newPassword, validation: $viewModel.validation[1])
                    .labelWidthSize(5)
                    .customIcon(font: .title3)
                    .validationType(.password)
                    .isSecure()
                
                ListInputField(icon: "key.horizontal", label: nil, placeholder: "Confirm new password", resetter: $viewModel.resetTextFields, text: $viewModel.confirmNewPassword, validation: $viewModel.validation[2])
                    .labelWidthSize(5)
                    .customIcon(font: .title3)
                    .validationType(.confirmPassword(
                        mainPassword: viewModel.newPassword,
                        errorMessage: "New passwords must be the same"
                    ))
                    .isSecure()
            }
        }
        .navigationTitle("Change password")
        .toolbar {
            Button("Save") {
                Task {
                    await viewModel.saveNewPassword()
                }
            }
            .fontWeight(.semibold)
            .disabled(!viewModel.buttonActive())
        }
        .animation(.default, value: viewModel.buttonActive())
        .animation(.default, value: viewModel.isLoading)
    }
}

#Preview {
    NavigationStack {
        SettingsChangePasswordView()
    }
}
