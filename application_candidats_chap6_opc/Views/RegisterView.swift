//
//  RegisterView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var model: RegisterViewModel
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmedPassword: String = ""
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                Text("Register")
                    .font(.system(.largeTitle, design: .default, weight: .medium))
                    .padding(.top, 20)
                CustomPrompt(title: "First Name", promptValue: $model.firstName)
                    .padding(.top, 20)
                CustomPrompt(title: "Last Name", promptValue: $model.lastName)
                    .padding(.top, 20)
                CustomPrompt(title: "Email", promptValue: $model.email)
                    .padding(.top, 20)
                CustomPassword(title: "Password", addForgotPasswordIndication: false , promptValue: $model.password)
                    .padding(.top, 20)
                CustomPassword(title: "Confirm Password", addForgotPasswordIndication: false, promptValue: $model.confirmedPassword)
                    .padding(.top, 20)
                Button {
                    Task {
                        await model.register()
                    }
                } label: {
                    Text("Create")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(width: geo.size.width/4)
                        .padding()
                        .border(.black, width: 2)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .navigationBarBackButtonHidden(true)
                .alert("Register new account", isPresented: $model.needToPresentAlert) {
                    Button {
                        if model.alert == .registerSuccess {
                            dismiss()
                        }
                    } label: {
                        Text("Exit")
                    }
                } message: {
                    Text("\(String(describing: model.alert?.description ?? "chc"))")
                }
            }
            .padding(.horizontal, 40)
        }
    }
}
