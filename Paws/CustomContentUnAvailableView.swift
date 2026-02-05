//
//  CustomContentUnAvailableView.swift
//  Paws
//
//  Created by ehsanyaqoob on 05/02/2026.
//

import SwiftUI

struct CustomContentUnAvailableView: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        ContentUnavailableView {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 96)
            
            Text(title)
                .font(.title)
        }  description: {
            Text(description)
        }
        .foregroundStyle(.tertiary)
    }
}

#Preview {
    CustomContentUnAvailableView(
        icon:"cat.circle",
        title: "No Photo",
        description: "Add a photo to get started."
    )
}
