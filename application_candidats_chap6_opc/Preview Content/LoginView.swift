//
//  LoginView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var model: LoginOperation
    
    var body: some View {
        NavigationStack {
            CustomPrompt(title: "Email/Username", promptValue: $model.email) {}
            CustomPassword(title: "Password", promptValue: $model.password)
            VStack() {
                NavigationLink(destination: SignInView()) {
                    Text("Sign in")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    print("pressed")
                    Task {
                        await model.login()
                    }
                })
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
//
//#Preview {
//    LoginView(email: "", password: "")
//}
