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
    
    let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    @MainActor
  func login() async throws {
      let service = ApiServiceV2(session: session)
      let parameters = ["email": self.email, "password": self.password]
      if !isRecipientWellFormattedForEmail(email) {
          self.needToPresentAlert.toggle()
          self.alert = .invalidEmail
          return
      }
      do {
          let request = try await service.fetch(endpoint: .auth, parametersBody: parameters, responseType: Login.self)
          switch request {
          case .success(let response):
              let userDefaults = UserDefaults.standard
              userDefaults.set(response?.token, forKey: "token")
              userDefaults.set(response?.isAdmin, forKey: "isAdmin")
            print("Successfully login with email: \(email) with token : \(String(describing: response?.token))")
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
