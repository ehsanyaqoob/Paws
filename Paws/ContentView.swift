//
//  ContentView.swift
//  Paws
//
//  Created by ehsanyaqoob on 05/02/2026.
//

import SwiftUI
import SwiftData

private struct PetCard: View {
    let pet: Pet
    let isEditing: Bool

    var body: some View {
        VStack {
            PetImage(pet: pet)
                .frame(height: 120)
            Spacer()
            Text(pet.name)
                .font(.title.weight(.light))
                .padding(.vertical)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .circular))
        .overlay(alignment: .topTrailing) {
            if isEditing {
                Menu {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        // Hook up deletion in parent if desired
                        
                    }
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.red)
                        .symbolRenderingMode(.multicolor)
                        .padding()
                }
            }
        }
    }
}

private struct PetImage: View {
    let pet: Pet

    var body: some View {
        Group {
            if let imageData = pet.photo, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                Image(systemName: "pawprint.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var pets: [Pet]
    @State private var path = [Pet]()
    @State private var isEditing: Bool = false
    let layout = [
        GridItem(.flexible(minimum: 120,)),
        GridItem(.flexible(minimum: 120,))
    ]
    
    func addPet() {
        isEditing = false
        let pet = Pet(name: "best friend")
        modelContext.insert(pet)
        // Navigate to EditPetView for the newly created pet
        path.append(pet)
    }
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: layout) {
                    GridRow {
                        ForEach(pets, id: \.id) { pet in
                            NavigationLink(value: pet) {
                                PetCard(pet: pet, isEditing: isEditing)
                            }
                            .foregroundStyle(.primary)
                            .buttonStyle(.plain)
                        } //.Loop
                    } //. Grid Row
                } //. GridLayout
                .padding(.horizontal)
            }  //.ScrollView
            .navigationTitle("Paws")
            .navigationDestination(for: Pet.self, destination: EditPetView.init)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
//                            modelContext.delete(pet)
                            try? modelContext.save()
                        }
                    } label: {
                        Image(systemName:"slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add a New Pet", systemImage: "plus.circle", action: addPet)
                }
            }
            .overlay {
                if pets.isEmpty {
                    CustomContentUnAvailableView(icon: "dog.circle", title: "no Pets", description: "add new pets to get started ")
                }
            }
        }
    }
}

#Preview("Sample Data") {
    ContentView()
        .modelContainer(Pet.preview)
}

#Preview ("No Data"){
    ContentView()
        .modelContainer(for: Pet.self, inMemory: true)
}

