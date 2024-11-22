//
//  RegisterOperation.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

class RegisterOperation: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var LastName: String = ""
    
    
    @MainActor
    func register() async {
        let parameters = ["email": self.email,
                          "password": self.password,
                          "firstName": self.firstName,
                          "lastName": self.firstName]
        
        do {
            let request = try await ApiService.shared.fetch(endpoint: .post(Route.register, parameters), responseType: Register.self)
            switch request {
            case .success(let success):
                print("Successfully registered")
            case .failure(let error):
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
