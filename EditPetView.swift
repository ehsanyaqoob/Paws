//
//  EditPetView.swift
//  Paws
//
//  Created by ehsanyaqoob on 05/02/2026.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPetView: View {
    // Add a pet to edit so the preview can instantiate this view
   @Bindable var pet: Pet
   @State private var photoPickerItem: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form{
            // Image
            if let imageData = pet.photo {
                if let image = UIImage(data:imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .circular))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 300)
                }
            } else {
                CustomContentUnAvailableView(
                    icon:"pawprint.circle",
                    title: "no photo",
                    description: "Add a photo of your favourite pet to make it easier to find out.")
                .padding(8)
            }
            
            // photo picker
            PhotosPicker(selection:$photoPickerItem, matching: .images) {
                Label("Select a Photo", systemImage: "photo.badge.plus")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            // text field
            TextField("Name", text: $pet.name)
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle.weight(.light))
                .padding(.vertical)
            // - Button
            Button {
                // Persisting changes is automatic with @Bindable + SwiftData; just dismiss
                dismiss()
            } label: {
                Text("Save")
                    .font(.title3.weight(.medium))
                    .padding(8)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
            .listRowSeparator(.hidden)

        }//: Form
        .listStyle(.plain)
        .navigationTitle("Edit \(pet.name)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") { dismiss() }
            }
        }
        .onChange(of: photoPickerItem) {
            Task {
                pet.photo = try? await photoPickerItem?.loadTransferable(type: Data.self)
            }
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, configurations: configuration)
    let sample = Pet(name: "Daisy")

    return NavigationStack {
        EditPetView(pet: sample)
    }
}
