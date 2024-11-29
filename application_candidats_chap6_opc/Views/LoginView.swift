//
//  LoginView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var model: LoginOperation
    @State private var shouldNavigate = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            CustomPrompt(title: "Email/Username", promptValue: $model.email) {}
            CustomPassword(title: "Password", promptValue: $model.password)
            VStack() {
                Button {
                    isLoading = true
                    Task {
                        try await model.login()
                        if model.needToPresentAlert {
                            shouldNavigate = false
                        } else {
                            shouldNavigate = true
                        }
                        isLoading = false
                    }
                } label: {
                    Text("Sign in")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isLoading)
                .padding()
                .alert(isPresented: $model.needToPresentAlert) {
                            Alert(
                                title: Text("Not able to connect the user"),
                                message: Text("You received the error: \(model.alert.debugDescription)"),
                                dismissButton: .destructive(Text("Exit")))
                        }
                NavigationLink(isActive: $shouldNavigate) {
                    CandidatesView()
                } label: {
                    EmptyView()
                }
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
    }
}
