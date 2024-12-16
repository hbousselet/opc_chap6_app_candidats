//
//  application_candidats_chap6_opcTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import XCTest
@testable import application_candidats_chap6_opc

final class ApiServiceTest: XCTestCase {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    lazy var api: ApiService = {
        ApiService(session: session)
    }()
    
    func testLoginOk() async throws {
        let mockLogin = """
                {
                    "isAdmin": true,
                    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY"
                }
            """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                                    statusCode: 200,
                                                    httpVersion: nil,
                                                    headerFields: [:])!
            return (response, mockLogin)
        }
        let fakeEmail = "hug.bou@gmail.com"
        let fakePassword = "toto123"
        
        let result = await api.fetch(endpoint: .auth(email: fakeEmail, password: fakePassword), responseType: Login.self)
        do {
            let auth = try result.get()
            XCTAssertEqual(auth?.isAdmin, true)
            XCTAssertEqual(auth?.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testLoginInvalidData() async throws {
        let invalidJSONData = "invalid JSON".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let invalidJSONResponse = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (invalidJSONResponse, invalidJSONData)
        }
        
        let fakeEmail = "hug.bou@gmail.com"
        let fakePassword = "toto123"
        
        let result = await api.fetch(endpoint: .auth(email: fakeEmail, password: fakePassword), responseType: Login.self)
        
        do {
            let auth = try result.get()
            XCTAssertNil(auth)
        } catch {
            XCTAssert(error == CustomErrors.invalidDecode)
        }
    }
    
    func testLoginInvalidResponse() async throws {
        let mockLogin = """
                {
                    "isAdmin": true,
                    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY"
                }
            """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let invalidJSONResponse = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: 300,
                httpVersion: nil,
                headerFields: nil
            )!
            return (invalidJSONResponse, mockLogin)
        }
        
        let fakeEmail = "hug.bou@gmail.com"
        let fakePassword = "toto123"
        
        let result = await api.fetch(endpoint: .auth(email: fakeEmail, password: fakePassword), responseType: Login.self)
        
        do {
            let auth = try result.get()
            XCTAssertNil(auth)
        } catch {
            XCTAssert(error == CustomErrors.invalidResponse)
        }
    }
    
    func testLoginInvalidDecode() async throws {
        let mockLogin = """
                {
                    "isNotAdmin": true,
                    "Troken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY"
                }
            """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                                    statusCode: 200,
                                                    httpVersion: nil,
                                                    headerFields: [:])!
            return (response, mockLogin)
        }
        let fakeEmail = "hug.bou@gmail.com"
        let fakePassword = "toto123"
        
        let result = await api.fetch(endpoint: .auth(email: fakeEmail, password: fakePassword), responseType: Login.self)
        do {
            let auth = try result.get()
            XCTAssertNil(auth)
        } catch {
            XCTAssert(error == CustomErrors.invalidDecode)
        }
    }
}
