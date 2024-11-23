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
                        await model.login()
                        shouldNavigate = true
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
