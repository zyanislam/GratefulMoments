//
//  MomentEntryView.swift
//  GratefulMoments
//
//  Created by Sheikh Fahad A. Islam on 15/11/25.
//

import SwiftUI
import PhotosUI

struct MomentEntryView: View {
    @State private var title = ""
    @State private var note = ""
    @State private var imageData: Data?
    @State private var newImage: PhotosPickerItem?

    var body: some View {
        NavigationStack{
            ScrollView{
                contentStack
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Grateful For")
        }
    }
    
    private var photoPicker: some View {
        PhotosPicker(selection: $newImage) {
            Group {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.largeTitle)
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.4, opacity: 0.32))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .onChange(of: newImage) {
            guard let newImage else { return }
            Task {
                imageData = try await newImage.loadTransferable(type: Data.self)
            }
        }
    }
    
    var contentStack: some View {
        VStack(alignment: .leading) {
            TextField(text: $title){
                Text("Enter your title")
            }
            .padding(.top, 40)
            .font(.title.bold())
            
            Divider()
            
            TextField("Write your note", text: $note, axis: .vertical) 
                .multilineTextAlignment(.leading)
                .lineLimit(5...Int.max)
            
            photoPicker
            }
        .padding()
    }
}

#Preview {
    MomentEntryView()
}
