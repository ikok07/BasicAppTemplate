//
//  HomePageMainView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 5.02.24.
//

import SwiftUI
import RealmSwift

struct HomePageMainView: View {
    
    @ObservedResults(User.self) private var userResults
    @Environment(AccountManager.self) private var accManager
    @Environment(NavigationManager.self) private var navManager
    
    var scrollToggle: Bool
    
    var body: some View {
        @Bindable var navManager = self.navManager
        
        NavigationStack(path: $navManager.homePath) {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        Spacer()
                        Text("Name: \(userResults.first?.name ?? "???")")
                            .id(0)
                        Spacer()
                    }
                    .onChange(of: self.scrollToggle) { oldValue, newValue in
                        withAnimation {
                            proxy.scrollTo(0, anchor: .top)
                        }
                    }
                }
            }
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
}

#Preview {
    HomePageMainView(scrollToggle: false)
        .environment(AccountManager.shared)
        .environment(NavigationManager.shared)
}
