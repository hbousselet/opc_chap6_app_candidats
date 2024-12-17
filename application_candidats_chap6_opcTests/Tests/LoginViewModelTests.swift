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
    
    func testLoginNOKWrongFormattedEmail() async {
        api.data = nil
        api.error = nil
        api.shouldSuccess = false
        
        let loginViewModel = LoginOperation(serviceApi: api<Login>)
        
        loginViewModel.email = "hug.bou@gmail"
        loginViewModel.password = "toto123"
        
        await loginViewModel.login()
        
        XCTAssertTrue(loginViewModel.needToPresentAlert)
        XCTAssert(loginViewModel.alert == .invalidEmail)
    }
    
    func testLoginNOKInvalidResponse() async {
        api.data = Login(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY",
                         isAdmin: false)
        api.error = .invalidResponse
        api.shouldSuccess = false
        
        let loginViewModel = LoginOperation(serviceApi: api<Login>)
        
        loginViewModel.email = "hug.bou@gmail.com"
        loginViewModel.password = "toto123"
        
        await loginViewModel.login()
        
        XCTAssertTrue(loginViewModel.needToPresentAlert)
        XCTAssert(loginViewModel.alert == .invalidResponse)
    }
}
