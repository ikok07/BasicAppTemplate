//
//  ProfileSettingsUserView.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 17.12.23.
//

import SwiftUI
import PhotosUI

struct ProfileSettingsUserView: View {
    
    let imageUrl: String
    let name: String
    let email: String
    var localImage: UIImage? = nil
    
    @Binding var imageItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PhotosPicker(selection: $imageItem, matching: .images) {
                    if let localImage {
                        Image(uiImage: localImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .overlay {
                                ProfileSettingsImageOverlayView()
                            }
                    } else {
                        asyncImage()
                            .overlay {
                                ProfileSettingsImageOverlayView()
                            }
                    }
                }
                Spacer()
            }
            .padding(.bottom, 1)
            
            Text(self.name)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(self.email)
                .foregroundStyle(.gray)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .listRowBackground(Color.clear)
    }
    
    func asyncImage() -> some View {
        AsyncImage(url: URL(string: imageUrl) ?? URL(string: "https://")) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
        } placeholder: {
            Image(systemName: "person.crop.circle")
                .foregroundStyle(.customSecondary)
                .font(.system(size: 75))
                .frame(width: 75)
                .clipped(antialiased: true)
        }
    }
    
}

#Preview {
    ProfileSettingsUserView(imageUrl: "https://", name: "John Smith", email: "kokmarok@gmail.com", imageItem: .constant(nil))
}
