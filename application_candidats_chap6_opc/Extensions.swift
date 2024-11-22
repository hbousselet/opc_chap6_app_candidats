//
//  Extensions.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI


struct ActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    var role: ButtonRole?
    let action: () -> Void
    
    init(_ title: String? = nil,
         systemImage: String? = nil,
         role: ButtonRole? = nil,
         action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }
    
    var body: some View {
        Button(role: role) {
            withAnimation {
                action()
            }
        } label: {
            if let title, let systemImage {
                Label(title, systemImage: systemImage)
            } else if let title {
                Text(title)
            } else if let systemImage {
                Image(systemName: systemImage)
            }
        }
    }
}

struct CustomPrompt: View {
    var title: String
    @Binding var promptValue: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField("", text: $promptValue)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
        }
        .padding(.horizontal, 20)
    }
}

struct CustomPassword: View {
    var title: String
    @Binding var promptValue: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            SecureField("", text: $promptValue)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
        }
        .padding(.horizontal, 20)
    }
}
