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
    @Published var confirmedPassword: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var alert: CustomErrors?
    @Published var needToPresentAlert = false
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
        
        checkFirstNameValidity()
        checkLastNameValidity()
        checkPasswordValidity()
        checkPasswordIsTheSame()
        checkEmailValidity()
        
        if self.needToPresentAlert {
            return
        }
        
        let service = ApiServiceV2(session: session)
        do {
            let request = try await service.fetch(endpoint: .userRegister, parametersBody: parameters, responseType: Register.self)
            switch request {
            case .success(_):
                self.needToPresentAlert.toggle()
                self.alert = .registerSuccess
                print("Successfully registered")
            case .failure(let error):
                self.needToPresentAlert.toggle()
                self.alert = error
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    private func checkFirstNameValidity() {
        if self.firstName.isEmpty {
            self.needToPresentAlert = true
            self.alert = .firstNameIsEmpty
        }
    }
    
    private func checkLastNameValidity() {
        if self.lastName.isEmpty {
            self.needToPresentAlert = true
            self.alert = .lastNameIsEmpty
        }
    }
    
    private func checkPasswordValidity() {
        if self.password.isEmpty && self.password.count > 3 {
            self.needToPresentAlert = true
            self.alert = .passwordIsEmpty
        }
    }
    
    private func checkPasswordIsTheSame() {
        if self.password != self.confirmedPassword {
            self.needToPresentAlert = true
            self.alert = .passwordNotTheSame
        }
    }
    
    private func checkEmailValidity() {
        if self.email.isEmpty {
            self.needToPresentAlert = true
            self.alert = .emailIsEmpty
        } else if !isRecipientWellFormattedForEmail(self.email) {
            self.needToPresentAlert = true
            self.alert = .emailIsNotValid
        }
    }
}

struct Register: Decodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}
