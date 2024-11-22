//
//  RegisterView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmedPassword: String = ""
    
    var body: some View {
        NavigationStack {
            CustomPrompt(title: "First Name", promptValue: $firstName) {}
            CustomPrompt(title: "Last Name", promptValue: $lastName) {}
            CustomPrompt(title: "Email", promptValue: $email) {}
            CustomPassword(title: "Password", promptValue: $password)
            CustomPassword(title: "Confirm Password", promptValue: $confirmedPassword)
            Button {
                //check if creation is ok dans viewModel, si ok => dismiss
                dismiss()
            } label: {
                Text("Create")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .navigationTitle("Register")
        }
    }
}


#Preview {
    RegisterView(firstName: "Bla", lastName: "te", email: "hd", password: "nd", confirmedPassword: "df")
}
