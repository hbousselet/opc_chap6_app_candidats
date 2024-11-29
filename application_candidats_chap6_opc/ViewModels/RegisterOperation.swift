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
    let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    @MainActor
    func register() async {
        let parameters = ["lastName": self.firstName,
                          "password": self.password,
                          "firstName": self.firstName,
                          "email": self.email]
        
        let service = ApiService(session: session)
        do {
            let request = try await service.fetch(endpoint: .post(Route.register, parameters), responseType: Register.self)
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

struct Register: Decodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}
