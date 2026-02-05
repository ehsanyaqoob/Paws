//
//  PawsApp.swift
//  Paws
//
//  Created by ehsanyaqoob on 05/02/2026.
//

import SwiftUI
import SwiftData

@main
struct PawsApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Pet.self)
        }
    }
}
