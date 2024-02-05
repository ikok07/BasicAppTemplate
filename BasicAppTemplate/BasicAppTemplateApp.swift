//
//  BasicAppTemplateApp.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 9.12.23.
//

import SwiftUI
import iOS_Backend_SDK
import GoogleSignIn


@main
struct BasicAppTemplateApp: App {
    
    let migrator = RealmMigrator()
    
    init() {
        print(String(describing: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path))
        
        Backend.shared.config = BackendConfig(
            debugMode: true,
            bundleId: K.App.bundleID,
            deviceToken: NotificationManager.shared.deviceToken,
            language: "en",
            googleClientID: K.App.googleClientID,
            backendUrls: K.App.backendUrls,
            errors: []
        )
        
        let loginStatus = AccountManager.shared.loginStatus
        if loginStatus == nil {
            AccountManager.createNewLoginStatus()
        }
    }
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var navigationManager = NavigationManager.shared
    @State private var uxComponents = UXComponents.shared
    @State private var accManager = AccountManager.shared
    @State private var notificationManager = NotificationManager.shared
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navigationManager)
                .environment(uxComponents)
                .environment(accManager)
                .environment(notificationManager)
                .onOpenURL(perform: { url in
                    Task {
                        await OpenURL.main.open(url: url)
                    }
                })
                .onAppear {
//                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                        if let error {
//                            print("Error restoring google sign in state: \(error)")
//                            UXComponents.shared.showMsg(type: .error, text: CustomError.noUserAvailable.localizedDescription)
//                            Task { await AccountManager.shared.logout(force: true) }
//                            return
//                        }
//                    }
                }
        }
    }
}
