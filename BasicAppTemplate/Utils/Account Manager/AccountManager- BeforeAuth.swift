//
//  AccountManager- BeforeAuth.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 17.12.23.
//

import UIKit
import RealmSwift
import iOS_Backend_SDK

extension AccountManager {
    
    static func createNewLoginStatus() {
        let loginStatus = LoginStatus(isLoggedIn: false, hasDetails: false)
        DB.shared.save(loginStatus)
    }
    
    @MainActor func saveNewLoginStatus(hasDetails: Bool) async {
        DB.shared.update {
            self.loginStatus?.isLoggedIn = true
            self.loginStatus?.hasDetails = hasDetails
        }
    }
    
    @MainActor func finishEmailVerification() async {
        if NavigationManager.shared.hasSetup {
            do {
                try await self.downloadUserDetails()
                await saveNewLoginStatus(hasDetails: true)
            } catch {
                print(error)
                await saveNewLoginStatus(hasDetails: false)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                NavigationManager.shared.beforeAuthPath = .init()
            }
        } else {
            await saveNewLoginStatus(hasDetails: false)
            NavigationManager.shared.navigate(to: .tabViewManager, path: .beforeAuth)
        }
    }
    
    @MainActor
    func signInWithGoogle() async {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        await Backend.shared.handleSignInWithGoogle(
            rootVC: presentingViewController) { result in
                switch result {
                case .success(let response):
                    if let backendUser = response.data?.user {
                        let user = User(_id: try! ObjectId(string: backendUser._id), oauthProviderUserId: backendUser.oauthProviderUserId, token: response.token ?? "", name: backendUser.name, email: backendUser.email, photo: backendUser.photo, oauthProvider: backendUser.oauthProvider)
                        
                        DB.shared.save(user, shouldBeOnlyOneOfType: User.self)
                        await self.finishEmailVerification()
                    }
                case .failure(let error):
                    UXComponents.shared.showMsg(type: .error, text: error.localizedDescription)
                }
            }
    }
    
}
