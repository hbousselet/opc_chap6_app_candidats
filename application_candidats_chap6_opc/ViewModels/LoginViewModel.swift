//
//  LoginViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

class LoginOperation: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alert: CustomErrors?
    @Published var needToPresentAlert = false
    
    let api: ApiService
    
    init(serviceApi: ApiService? = nil) {
        self.api = serviceApi ?? DefaultApiService(session: .shared)
    }
    
    @MainActor
    func login() async {
        if !isRecipientWellFormattedForEmail(email) {
            self.needToPresentAlert = true
            self.alert = .invalidEmail
            return
        }
        let authentication = await api.fetch(endpoint: .auth(email: self.email, password: self.password), responseType: Login.self)
        do {
            let auth = try authentication.get()
            let userDefaults = UserDefaults.standard
            if let auth {
                userDefaults.set(auth.token, forKey: "token")
                userDefaults.set(auth.isAdmin, forKey: "isAdmin")
                print("Successfully login with email: \(email) with token : \(String(describing: auth.token))")
            }
        } catch {
            print(error)
            alert = error
            needToPresentAlert = true
        }
    }
}

struct Login: Decodable {
    let token: String
    let isAdmin: Bool
}
