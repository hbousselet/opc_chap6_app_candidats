//
//  application_candidats_chap6_opcTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import XCTest
@testable import application_candidats_chap6_opc

class MockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    //This closure will take as its input a request and will return an HTTPURLResponse and some Data.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No request provided")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            XCTFail("Error handling the request: \(error)")
        }
    }
    
    override func stopLoading() {}
}

final class ApiServiceTest: XCTestCase {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    lazy var api: ApiService = {
        ApiService(session: session)
    }()
    
    func testLogin() async throws {
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
        
        let result = try await api.fetch(endpoint: .post(.auth, nil), responseType: Login.self)
        switch result {
        case .success(let response):
            XCTAssertEqual(response?.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.66y2jHqt-w3dQgc-W9sHMBhDN7BIHOq8X7IL3H--NzY")
            XCTAssertEqual(response?.isAdmin, true)
        case .failure(let error) :
            XCTAssertNil(error)
        }
    }
}

final class application_candidats_chap6_opcTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
