//
//  ProfileSettingsImageOverlayView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 5.02.24.
//

import SwiftUI

struct ProfileSettingsImageOverlayView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "camera.fill")
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7))
                    .background(Color.accentColor)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(.listBackground, lineWidth: 4)
                    }
            }
        }
    }
}

#Preview {
    ProfileSettingsImageOverlayView()
}
