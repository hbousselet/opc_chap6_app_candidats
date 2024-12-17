//
//  RegisterViewModelTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues BOUSSELET on 15/12/2024.
//

import Testing
import Foundation
@testable import application_candidats_chap6_opc

struct RegisterViewModelTests {
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        return URLSession(configuration: configuration)
    }()

    @Test mutating func registerOkTest() async {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.registerSuccess)
    }
    
    @Test mutating func registerFirstNameEmptyNOkTest() async {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = ""
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.firstNameIsEmpty)
    }
    
    @Test mutating func registerLastNameEmptyNOkTest() async {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = ""
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.lastNameIsEmpty)
    }
    
    @Test mutating func registerEmailIsEmptyTest() async {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = ""
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.emailIsEmpty)
    }
    
    @Test mutating func registerEmailIsNotValidTest() async {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = "hugues.bousselet@gmail"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.emailIsNotValid)
    }
    
    @Test mutating func registerPasswordNotTheSameTest() async {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test12"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.passwordNotTheSame)
    }
    
    @Test mutating func registerPasswordIsEmptyTest() async {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = ""
        registerViewModel.confirmedPassword = ""
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.passwordIsEmpty)
    }
    
    @Test mutating func registerPasswordIsTooSmallTest() async throws {
        let mockRegister = "".data(using: .utf8)!
        
        MockURLSessionProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockRegister)
        }
        
        let registerViewModel = RegisterOperation(session: session)
        
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "te"
        registerViewModel.confirmedPassword = "te"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        #expect(registerViewModel.alert == CustomErrors.passwordIsEmpty)
    }
}
