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
        GeometryReader { geo in
            NavigationStack {
                Text("Login")
                    .font(.system(.largeTitle, design: .default, weight: .medium))
                VStack() {
                    CustomPrompt(title: "Email/Username", promptValue: $model.email) 
                    CustomPassword(title: "Password", addForgotPasswordIndication: true, promptValue: $model.password)
                    Button {
                        isLoading = true
                        Task {
                            await model.login()
                            if model.needToPresentAlert {
                                shouldNavigate = false
                            } else {
                                shouldNavigate = true
                            }
                            isLoading = false
                        }
                    } label: {
                        Text("Sign in")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(width: geo.size.width/4)
                            .padding()
                            .border(.black, width: 2)
                    }
                    .disabled(isLoading)
                    .padding()
                    .padding(.horizontal)
                    .alert("Important message", isPresented: $model.needToPresentAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("\(String(describing: model.alert?.description ?? "chc"))")
                    }
                    NavigationLink(isActive: $shouldNavigate) {
                        CandidatesView()
                    } label: {
                        EmptyView()
                    }
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(width: geo.size.width/4)
                            .padding()
                            .border(.black, width: 2)
                    }
                }
                .padding(.top)
            }
        }
    }
}
