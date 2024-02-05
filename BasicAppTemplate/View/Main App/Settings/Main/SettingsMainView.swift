//
//  SettingsMainView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 17.12.23.
//

import SwiftUI
import RealmSwift

struct SettingsMainView: View {
    
    @Environment(NavigationManager.self) private var navManager
    @Environment(AccountManager.self) private var accManager
    @Environment(UXComponents.self) private var uxComponents
    
    @ObservedResults(User.self) private var userResults
    
    @State private var viewModel = ViewModel()
    
    var scrollToggle: Bool
    
    var body: some View {
        @Bindable var navManager = navManager
        
        NavigationStack(path: $navManager.settingsPath) {
            ScrollViewReader { proxy in
                List {
                    Section("Your profile") {
                        SettingsMainPageUserView(imageUrl: userResults.first?.photo ?? "https://", username: userResults.first?.name ?? "No username", email: userResults.first?.email ?? "No email")
                            .id(0)
                    }
                    
                    Section("General settings") {
                        ListCustomButton(icon: "person.circle", label: "Profile settings", hasChevron: true) {
                            NavigationManager.shared.navigate(to: .profileSetttings, path: .settings)
                        }
                        
                        ListCustomButton(icon: "key.horizontal", label: "Change password", hasChevron: true) {
                            NavigationManager.shared.navigate(to: .changePasswordSettings, path: .settings)
                        }
                        
                        ListCustomButton(icon: "bell", label: "Notifications", hasChevron: true) {
                            NavigationManager.shared.navigate(to: .notificationSettings, path: .settings)
                        }
                    }
                    
                    Section("Danger zone") {
                        ListCustomButton(icon: "rectangle.portrait.and.arrow.forward", label: "Log out", hasChevron: false) {
                            Task {
                                await accManager.logout()
                            }
                        }
                        .buttonPadding(0)
                        .iconFont(.title3)
                        .iconColor(.red)
                        .textColor(.red)
                    }
                }
                .navigationTitle("Settings")
                .withNavigationDestinations()
                .onChange(of: self.scrollToggle) { oldValue, newValue in
                    withAnimation {
                        proxy.scrollTo(0, anchor: .top)
                    }
                }
            }
        }
        .withCustomMessage()
        .withWholeScreenLoader()
        .refreshable {
            await Task {
                do {
                    try await accManager.downloadUser()
                } catch {
                    print("Error downloading latest user info! \(error)")
                }
            }.value
        }
    }
}

#Preview {
    SettingsMainView(scrollToggle: false)
        .environment(NavigationManager.shared)
        .environment(AccountManager.shared)
        .environment(UXComponents.shared)
}
