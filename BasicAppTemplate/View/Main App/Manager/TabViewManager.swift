//
//  TabViewManager.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 13.12.23.
//

import SwiftUI
import RealmSwift

struct TabViewManager: View {
    
    @Environment(AccountManager.self) private var accManager
    
    @Bindable private var viewModel = ViewModel()
    @ObservedResults(User.self) private var userResults
    
    var body: some View {
        TabView(selection: viewModel.tabSelection()) {
            HomePageMainView(scrollToggle: viewModel.scrollHomePage)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(Tab.home)
            
            SettingsMainView(scrollToggle: viewModel.scrollSettingsPage)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(Tab.settings)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if !accManager.userInitialized {
                Task {
                    do {
                        try await accManager.downloadUser()
                        try await accManager.downloadUserDetails()
                        accManager.userInitialized = true
                    } catch {
                        print("Error downloading latest user info! \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    TabViewManager()
        .environment(NavigationManager.shared)
        .environment(AccountManager.shared)
}
