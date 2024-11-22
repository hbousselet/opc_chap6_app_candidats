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
    
    @MainActor
    func login() async {
        let parameters = ["email": self.email, "password": self.password]
        do {
            let request = try await ApiService.shared.fetch(endpoint: .post(Route.auth, parameters), responseType: Login.self)
            switch request {
            case .success(let response):
                ApiService.token = response?.token
                print("Successfully login with email: \(email)")
            case .failure(let error):
                //TO DO - rajouter une alerte
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    
    
}
