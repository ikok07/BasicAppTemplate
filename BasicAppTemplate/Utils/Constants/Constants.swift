//
//  Constants.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 17.12.23.
//

import Foundation
import iOS_Backend_SDK


struct K {
    
    struct App {
        static let bundleID = "com.example.app"
        static let googleClientID = "700936905181-mk72ktis0jujiib4e1rrn9ga4u15ecuq.apps.googleusercontent.com"
        static let assetServerUrl = "https://wellsavor.com"
        static let backendUrl = "http://localhost:8080"
        
        static let backendUrls: BackendUrls = .init(baseUrl: Self.backendUrl, constantPrefix: "/en/api/", endpoints: [
            // User
            .init(types: [.deleteUser, .getUser, .updateUser], version: .v1, path: "/user/me"),
            .init(types: [.getUserDetails], version: .v1, path: "/user/{userId}/details"),
            
            // Before Auth
            .init(types: [.resendConfirmEmail], version: .v2, path: "/user/email/resend"),
            .init(types: [.login], version: .v2, path: "/user/login"),
            .init(types: [.loginConfirm], version: .v2, path: "/user/login/confirm/{token}"),
            .init(types: [.requestResetPassword], version: .v1, path: "/user/password/reset"),
            .init(types: [.resetPassword], version: .v1, path: "/user/password/reset/{token}"),
            .init(types: [.emailConfirm], version: .v2, path: "/user/email/confirm/{token}"),
            .init(types: [.signup], version: .v2, path: "/user/signup/basic"),
            .init(types: [.signInWithGoogle], version: .v1, path: "/user/oauth2/google"),
            .init(types: [.signInWithApple], version: .v1, path: "/user/oauth2/apple"),
            .init(types: [.createUserDetails], version: .v1, path: "/user/{userId}/details"),
            
            // Settings
            .init(types: [.resetPasswordByCurrentOne], version: .v1, path: "/user/updatePassword"),
            .init(types: [.logout], version: .v1, path: "/user/logout"),
        ])
    }
    
}
