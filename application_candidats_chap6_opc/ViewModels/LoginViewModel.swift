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
    @Published var alert: APIErrors?
    @Published var needToPresentAlert = false
    
    let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    @MainActor
  func login() async throws {
      let service = ApiService(session: session)
      let parameters = ["email": self.email, "password": self.password]
      do {
          let request = try await service.fetch(endpoint: .post(Route.auth, parameters), responseType: Login.self)
          switch request {
          case .success(let response):
              let userDefaults = UserDefaults.standard
              userDefaults.set(response?.token, forKey: "token")
              userDefaults.set(response?.isAdmin, forKey: "isAdmin")
              print("Successfully login with email: \(email)")
          case .failure(let error):
              //TO DO - rajouter une alerte
              print(error)
              alert = error
              needToPresentAlert.toggle()
          }
      } catch {
          print(error)
      }
    }
}

struct Login: Decodable {
    let token: String
    let isAdmin: Bool
}
