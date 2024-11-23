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
    @Published var lastName: String = ""
    
    
    @MainActor
    func register() async {
        let parameters = ["lastName": self.firstName,
                          "password": self.password,
                          "firstName": self.firstName,
                          "email": self.email]
        
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
