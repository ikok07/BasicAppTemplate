//
//  CustomSignInWithAppleButton.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 10.12.23.
//

import SwiftUI
import AuthenticationServices
import iOS_Backend_SDK
import RealmSwift
import Toolchain


@MainActor
func getSignInWidthAppleButton(scheme: ColorScheme) -> some View {
    let nonce = Nonce()
    let state = Nonce()
    
    return SignInWithAppleButton(.signIn) { request in
        UXComponents.shared.showLoader(text: "Signing in..." )
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.description
        request.state = state.description
    } onCompletion: { result in
        Task {
            await Backend.shared.completeSignInWithApple(result: result, nonce: nonce) { backendResult in
                switch backendResult {
                case .success(let response):
                    guard let backendUser = response.data?.user else {
                        UXComponents.shared.showMsg(type: .error, text: CustomError.signInWithAppleFailed.localizedDescription)
                        UXComponents.shared.showWholeScreenLoader = false
                        return
                    }
                    
                    let user = User(_id: try! ObjectId(string: backendUser._id), oauthProviderUserId: backendUser.oauthProviderUserId, token: response.token, name: backendUser.name, email: backendUser.email, photo: backendUser.photo, oauthProvider: backendUser.oauthProvider)
                    DB.shared.save(user, shouldBeOnlyOneOfType: User.self)
                    await AccountManager.shared.finishEmailVerification()
                    UXComponents.shared.showWholeScreenLoader = false
                case .failure(let error):
                    UXComponents.shared.showMsg(type: .error, text: error.localizedDescription)
                    UXComponents.shared.showWholeScreenLoader = false
                }
            }
        }
    }
    .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
}
