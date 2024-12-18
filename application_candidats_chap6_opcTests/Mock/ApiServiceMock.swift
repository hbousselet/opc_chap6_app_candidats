//
//  ApiServiceMock.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues BOUSSELET on 16/12/2024.
//

import Foundation

class MockURLSessionProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    //This closure will take as its input a request and will return an HTTPURLResponse and some Data.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        guard let handler = MockURLSessionProtocol.requestHandler else { return }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            print(error)
        }
    }
    
    override func stopLoading() {}
}
