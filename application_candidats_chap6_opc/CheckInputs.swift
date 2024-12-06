//
//  CheckInputs.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues BOUSSELET on 04/12/2024.
//

import Foundation

public func isRecipientWellFormattedForEmail(_ recipient: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    print("email enered: \(recipient) and isValid: \(emailPred.evaluate(with: recipient))")
    return emailPred.evaluate(with: recipient)
}

public func isRecipientWellFormattedForPhoneNumber(_ phoneNumber: String) -> Bool {
    let phoneNumberRegex = "^(\\+33[1-9]|0[1-9])[0-9]{8}$"
    let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
    print("phone: \(phoneNumber) with regex: \(phoneNumberPredicate.evaluate(with: phoneNumber))")
    return phoneNumberPredicate.evaluate(with: phoneNumber)
}
