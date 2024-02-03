//
//  SettingsMainPageUserView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 17.12.23.
//

import SwiftUI

struct SettingsMainPageUserView: View {
    
    let imageUrl: String
    let username: String
    let email: String
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: imageUrl) ?? URL(string: "https://")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .foregroundStyle(.customSecondary)
                    .font(.system(size: 47))
                    .frame(width: 50)
                    .clipped(antialiased: true)
            }
            
            VStack(alignment: .leading) {
                Text(username)
                    .font(.headline)
                
                Text(email)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            Spacer()
        }
        
    }
}

#Preview {
    SettingsMainPageUserView(imageUrl: "https://images.pexels.com/photos/1/pexels-photo-1172207.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", username: "John Smith", email: "kokmarok@gmail.com")
        .padding()
}
