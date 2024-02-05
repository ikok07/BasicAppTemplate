//
//  SignUpMainView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 10.12.23.
//

import SwiftUI

struct SignUpMainView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(NavigationManager.self) private var navigationManager
    
    @Bindable private var viewModel = ViewModel()
    
    @State private var name: String = ""
    
    var body: some View {
        @Bindable var navigationManager = navigationManager
        
        ScrollView {
            VStack(spacing: 30) {
                BeforeAuthHeadingView(icon: "building.columns.fill", heading: "Start your adventure", mainHeadingWord: "", subheadline: "Create a new account")
                
                VStack(spacing: 15) {
                    DefaultTextField(text: $viewModel.name, icon: "person.fill", placeholder: "Full name", validation: $viewModel.validations[0])
                        .validationType(.general)
                    
                    DefaultTextField(text: $viewModel.email, icon: "envelope.fill", placeholder: "Your email", validation: $viewModel.validations[1])
                        .validationType(.email)
                        .disableCapitalisation()
                    
                    DefaultTextField(text: $viewModel.password, icon: "key.horizontal.fill", placeholder: "Password", validation: $viewModel.validations[2])
                        .validationType(.password)
                    
                    DefaultTextField(text: $viewModel.confirmPassword, icon: "key.horizontal.fill", placeholder: "Confirm password", validation: $viewModel.validations[3])
                        .validationType(.confirmPassword(
                            mainPassword: viewModel.password,
                            errorMessage: "Passwords must be the same"
                        ))
                }
                
                DefaultButton(
                    text: "Sign up",
                    isDisabled: viewModel.validations != Array(repeating: true, count: 4),
                    isLoading: viewModel.isLoading
                ) {
                    Task {
                        await viewModel.signUp()
                    }
                }
                
                MethodDividerView()
                
                VStack(spacing: 15) {
                    getSignInWidthAppleButton(scheme: colorScheme)
                        .frame(height: 40)
                        .padding(.horizontal)
                    
                    SignInWithGoogleButton()
                        .padding(.horizontal)
                }
                
                HStack(spacing: 5) {
                    Text("Already have an account?")
                        .foregroundStyle(.gray)
                    Button("Log in") {
                        navigationManager.navigate(to: .login, path: .beforeAuth)
                    }
                }
                .font(.subheadline)
                .fontWeight(.medium)
                
                Spacer()
            }
            .navigationTitle("Sign up")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .padding(.top)
            .scrollIndicators(.hidden)
            .onSubmit {
                if viewModel.validations == Array(repeating: true, count: 4) {
                    Task {
                        await viewModel.signUp()
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpMainView()
        .environment(NavigationManager.shared)
}
