//
//  viewModelTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues BOUSSELET on 15/12/2024.
//

@testable import application_candidats_chap6_opc
import XCTest

final class LoginViewModelTests: XCTestCase {
    var api: MockAPIService<Login>!
    
    override func setUp() {
        api = MockAPIService()
    }
    
    func testLoginOK() async {
        api.data = Login(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY",
                         isAdmin: false)
        api.error = nil
        api.shouldSuccess = true
        
        let loginViewModel = LoginOperation(serviceApi: api<Login>)
        loginViewModel.email = "hug.bou@gmail.com"
        loginViewModel.password = "toto123"
        
        await loginViewModel.login()
        let userDefaults = UserDefaults.standard
        let token = userDefaults.string(forKey: "token")
        let isAdmin = userDefaults.bool(forKey: "isAdmin")
        XCTAssertFalse(loginViewModel.needToPresentAlert)
        XCTAssertEqual(token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY")
        XCTAssertFalse(isAdmin)
    }
    
}

//final class LoginViewModelTests: XCTestCase {
//    lazy var session: URLSession = {
//        let configuration = URLSessionConfiguration.ephemeral
//        configuration.protocolClasses = [MockURLProtocol.self]
//        return URLSession(configuration: configuration)
//    }()
//    
//    
//    func testLoginOK() async {
//        let mockLogin = """
//                {
//                    "isAdmin": true,
//                    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY"
//                }
//            """.data(using: .utf8)!
//        
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                                    statusCode: 200,
//                                                    httpVersion: nil,
//                                                    headerFields: [:])!
//            return (response, mockLogin)
//        }
//        
//        let loginViewModel = LoginOperation(session: session)
//
//        loginViewModel.email = "hug.bou@gmail.com"
//        loginViewModel.password = "toto123"
//        
//        Task {
//            await loginViewModel.login()
//            let userDefaults = UserDefaults.standard
//            let token = userDefaults.string(forKey: "token")
//            let isAdmin = userDefaults.bool(forKey: "isAdmin")
//            XCTAssertFalse(loginViewModel.needToPresentAlert)
//            XCTAssertEqual(token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY")
//            XCTAssertFalse(isAdmin)
//        }
//    }
//    
//    func testLoginNOK() async {
//        let mockLogin = """
//                {
//                    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY"
//                }
//            """.data(using: .utf8)!
//        
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                                    statusCode: 200,
//                                                    httpVersion: nil,
//                                                    headerFields: [:])!
//            return (response, mockLogin)
//        }
//        
//        let loginViewModel = LoginOperation(session: session)
//        
//        loginViewModel.email = "hug.bou@gmail.com"
//        loginViewModel.password = "toto123"
//        
//        Task {
//            await loginViewModel.login()
//            XCTAssertTrue(loginViewModel.needToPresentAlert)
//            XCTAssertTrue(loginViewModel.alert == CustomErrors.invalidDecode)
//        }
//    }
//}
