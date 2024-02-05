//
//  ContentView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 9.12.23.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @ObservedResults(LoginStatus.self) private var loginStatusResults
    @Environment(NavigationManager.self) private var navManager
    @Environment(UXComponents.self) private var uxComponents
    @Environment(AccountManager.self) private var accManager
    
    var body: some View {
        @Bindable var uxComponents = self.uxComponents
        VStack {
            if let loginStatus = loginStatusResults.first {
                if loginStatus.isLoggedIn {
                    if navManager.hasSetup && !loginStatus.hasDetails {
                        SetupManager()
                    } else {
                        TabViewManager()
                    }
                } else {
                    LoginMainView()
                }
            } else {
                LoginMainView()
            }
        }
        .alert("Account deleted", isPresented: $uxComponents.showAccountDeleted) {
            Button("Done", action: { uxComponents.showAccountDeleted = false })
        } message: {
            Text("Please note that it may take up to a day to fully delete your data.")
        }
        .animation(.default, value: loginStatusResults.first?.isLoggedIn)
        .animation(.default, value: loginStatusResults.first?.hasDetails)
        .onChange(of: loginStatusResults.first) { oldValue, newValue in
            accManager.userInitialized = false
        }
    }
}

#Preview {
    ContentView()
        .environment(NavigationManager.shared)
        .environment(UXComponents.shared)
        .environment(AccountManager.shared)
}
