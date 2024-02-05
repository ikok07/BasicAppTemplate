//
//  AccountManager.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 10.12.23.
//

import Foundation
import RealmSwift
import Observation
import iOS_Backend_SDK
import UIKit

@Observable final class AccountManager {
    
    static let shared = AccountManager()
    private init() {}
    
    var userInitialized: Bool = false
    var logoutAttempts: Int = 0

    var user: User? {
        get {
            let user: User? = DB.shared.fetch()?.first
            return user?.thaw()
        }
    }
    
    var loginStatus: LoginStatus? {
        get {
            let status: LoginStatus? = DB.shared.fetch()?.first
            return status?.thaw()
        }
    }
    
    func convertBackendUser(_ backendUser: BackendUser, token: String?) -> User {
        return User(_id: try! ObjectId(string: backendUser._id),
                    oauthProviderUserId: backendUser.oauthProviderUserId,
                    token: token,
                    name: backendUser.name,
                    email: backendUser.email,
                    photo: backendUser.photo,
                    oauthProvider: backendUser.oauthProvider
        )
    }
    
    @MainActor
    func downloadUser() async {
        if let user {
            await Backend.shared.getUser(authToken: user.token ?? "") { result in
                switch result {
                case .success(let response):
                    if let backendUser = response.data {
                        DB.shared.save(self.convertBackendUser(backendUser, token: user.token))
                    } else {
                        UXComponents.shared.showMsg(type: .error, text: response.message ?? "?")
                    }
                case .failure(let error):
                    UXComponents.shared.showMsg(type: .error, text: error.localizedDescription)
                }
            }
        } else {
            UXComponents.shared.showMsg(type: .error, text: CustomError.noUserAvailable.localizedDescription)
        }
    }
    
    @MainActor
    func downloadUserDetails() async throws {
        if let user {
            var customError: CustomError?
            await Backend.shared.getUserDetails(userId: user._id.stringValue, authToken: user.token ?? "") { result in
                switch result {
                case .success(let response):
                    if let backendUserDetails = response.data?.userDetails {
                        DB.shared.update {
                            let userDetails = UserDetails(_id: try! ObjectId(string: backendUserDetails._id), userId: backendUserDetails.userId)
                            user.details = userDetails
                        }
                    }
                case .failure(let error):
                    customError = CustomError.fromText(text: error.localizedDescription)
                }
            }
            if let customError {
                throw customError
            }
        } else {
            throw CustomError.noUserAvailable
        }
    }
    
    @MainActor
    func logout(force: Bool = false) async {
        
        if force || self.logoutAttempts >= 3 {
            DB.shared.update {
                loginStatus?.logOut()
                self.logoutAttempts = 0
            }
            return
        }
        
        if let user {
            await Backend.shared.logOut(userToken: user.token ?? "", deviceToken: NotificationManager.shared.deviceToken) { result in
                switch result {
                case .success(_):
                    DB.shared.update {
                        loginStatus?.logOut()
                    }
                    
                    do {
                        try DB.shared.delete(user)
                    } catch {
                        UXComponents.shared.showMsg(type: .error, text: CustomError.cannotLogOut.localizedDescription)
                    }
                    
                    self.logoutAttempts = 0
                    NavigationManager.shared.clearPaths()
                case .failure(let error):
                    UXComponents.shared.showMsg(type: .error, text: error.localizedDescription)
                    self.logoutAttempts += 1
                }
            }
        }
    }
    
    @MainActor
    func deleteUser() async {
        if let user {
            let backendUser: BackendUser = .init(
                _id: user._id.stringValue,
                oauthProviderUserId: user.oauthProviderUserId,
                token: user.token,
                name: user.name,
                email: user.email,
                photo: user.photo,
                oauthProvider: user.oauthProvider
            )
            
            await Backend.shared.deleteUser(backendUser) { result in
                switch result {
                case .success(_):
                    await logout(force: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UXComponents.shared.showAccountDeleted = true
                    }
                case .failure(let error):
                    UXComponents.shared.showMsg(type: .error, text: error.localizedDescription)
                }
            }
        }
    }
}
