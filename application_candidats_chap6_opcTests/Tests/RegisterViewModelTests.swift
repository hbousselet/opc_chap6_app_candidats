//
//  RegisterViewModelTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues BOUSSELET on 15/12/2024.
//

@testable import application_candidats_chap6_opc
import XCTest

final class RegisterViewModelTests: XCTestCase {
    var api: MockAPIService<Register>!
    
    override func setUp() {
        api = MockAPIService()
    }
    
    func testRegisterOK() async {
        api.data = Register(email: "hugues.bousselet@gmail.com",
                            password: "test123",
                            firstName: "Hugues",
                            lastName: "Bousselet")
        api.error = nil
        api.shouldSuccess = true
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .registerSuccess)
    }
    
    func testRegisterNOK() async {
        api.data = nil
        api.error = .errorSessionData
        api.shouldSuccess = false
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .errorSessionData)
    }
    
    func testFirstNameEmptyNOkTests() async {
        api.data = nil
        api.error = nil
        api.shouldSuccess = true
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = ""
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .firstNameIsEmpty)
    }
    
    func testLastNameEmptyNOkTests() async {
        api.data = nil
        api.error = nil
        api.shouldSuccess = true
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "test123"
        registerViewModel.confirmedPassword = "test123"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = ""
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .lastNameIsEmpty)
    }
    
    func testPasswordEmptyNOkTests() async {
        api.data = nil
        api.error = nil
        api.shouldSuccess = true
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = ""
        registerViewModel.confirmedPassword = ""
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = "Bousselet"
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .passwordIsEmpty)
    }
    
    func testPasswordTooSmallNOkTests() async {
        api.data = nil
        api.error = nil
        api.shouldSuccess = true
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "12"
        registerViewModel.confirmedPassword = "12"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = ""
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .passwordIsEmpty)
    }
    
    func testPasswordNotTheSameNOkTests() async {
        api.data = nil
        api.error = nil
        api.shouldSuccess = true
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail.com"
        registerViewModel.password = "Molotov"
        registerViewModel.confirmedPassword = "Withings"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = ""
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .passwordNotTheSame)
    }
    
    func testEmailNotValidNOkTests() async {
        api.data = nil
        api.error = nil
        api.shouldSuccess = true
        
        let registerViewModel = RegisterOperation(serviceApi: api)
        registerViewModel.email = "hugues.bousselet@gmail"
        registerViewModel.password = "Molotov"
        registerViewModel.confirmedPassword = "Molotov"
        registerViewModel.firstName = "Hugues"
        registerViewModel.lastName = ""
        
        await registerViewModel.register()
        
        XCTAssertTrue(registerViewModel.needToPresentAlert)
        XCTAssert(registerViewModel.alert == .emailIsNotValid)
    }
    
    
    
}
//struct RegisterViewModelTests {
//    
//    lazy var session: URLSession = {
//        let configuration = URLSessionConfiguration.ephemeral
//        configuration.protocolClasses = [MockURLSessionProtocol.self]
//        return URLSession(configuration: configuration)
//    }()
//
//    @Test mutating func registerOkTest() async {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = "hugues.bousselet@gmail.com"
//        registerViewModel.password = "test123"
//        registerViewModel.confirmedPassword = "test123"
//        registerViewModel.firstName = "Hugues"
//        registerViewModel.lastName = "Bousselet"
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.registerSuccess)
//    }
//    
//    @Test mutating func registerFirstNameEmptyNOkTest() async {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = "hugues.bousselet@gmail.com"
//        registerViewModel.password = "test123"
//        registerViewModel.confirmedPassword = "test123"
//        registerViewModel.firstName = ""
//        registerViewModel.lastName = "Bousselet"
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.firstNameIsEmpty)
//    }
//    
//    @Test mutating func registerLastNameEmptyNOkTest() async {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = "hugues.bousselet@gmail.com"
//        registerViewModel.password = "test123"
//        registerViewModel.confirmedPassword = "test123"
//        registerViewModel.firstName = "Hugues"
//        registerViewModel.lastName = ""
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.lastNameIsEmpty)
//    }
//    
//    @Test mutating func registerEmailIsEmptyTest() async {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = ""
//        registerViewModel.password = "test123"
//        registerViewModel.confirmedPassword = "test123"
//        registerViewModel.firstName = "Hugues"
//        registerViewModel.lastName = "Bousselet"
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.emailIsEmpty)
//    }
//    
//    @Test mutating func registerEmailIsNotValidTest() async {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = "hugues.bousselet@gmail"
//        registerViewModel.password = "test123"
//        registerViewModel.confirmedPassword = "test123"
//        registerViewModel.firstName = "Hugues"
//        registerViewModel.lastName = "Bousselet"
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.emailIsNotValid)
//    }
//    
//    @Test mutating func registerPasswordNotTheSameTest() async {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = "hugues.bousselet@gmail.com"
//        registerViewModel.password = "test123"
//        registerViewModel.confirmedPassword = "test12"
//        registerViewModel.firstName = "Hugues"
//        registerViewModel.lastName = "Bousselet"
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.passwordNotTheSame)
//    }
//    
//    @Test mutating func registerPasswordIsEmptyTest() async {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = "hugues.bousselet@gmail.com"
//        registerViewModel.password = ""
//        registerViewModel.confirmedPassword = ""
//        registerViewModel.firstName = "Hugues"
//        registerViewModel.lastName = "Bousselet"
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.passwordIsEmpty)
//    }
//    
//    @Test mutating func registerPasswordIsTooSmallTest() async throws {
//        let mockRegister = "".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 201,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockRegister)
//        }
//        
//        let registerViewModel = RegisterOperation(session: session)
//        
//        registerViewModel.email = "hugues.bousselet@gmail.com"
//        registerViewModel.password = "te"
//        registerViewModel.confirmedPassword = "te"
//        registerViewModel.firstName = "Hugues"
//        registerViewModel.lastName = "Bousselet"
//        
//        await registerViewModel.register()
//        #expect(registerViewModel.alert == CustomErrors.passwordIsEmpty)
//    }
//}
