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
    
    lazy var api: DefaultApiService = {
        DefaultApiService(session: session)
    }()
    
    init(session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
    }
    
    @MainActor
    func register() async {
        
        checkFirstNameValidity()
        checkLastNameValidity()
        checkPasswordValidity()
        checkPasswordIsTheSame()
        checkEmailValidity()
        
        if self.needToPresentAlert {
            return
        }
        
        let request = await api.fetch(endpoint: .userRegister(email: self.email,
                                                                  password: self.password,
                                                                  firstName: self.lastName,
                                                                  lastName: self.firstName), responseType: Register.self)
        do {
            let _ = try request.get()
            self.needToPresentAlert.toggle()
            self.alert = .registerSuccess
            print("Successfully registered")
        } catch {
            self.needToPresentAlert.toggle()
            self.alert = error
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
        if self.password.isEmpty || self.password.count < 3 {
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
