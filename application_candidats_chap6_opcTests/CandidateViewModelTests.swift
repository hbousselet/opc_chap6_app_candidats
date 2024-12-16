//
//  CandidateViewModelTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues BOUSSELET on 15/12/2024.
//

import Testing
import Foundation
@testable import application_candidats_chap6_opc
struct CandidateViewModelTests {

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    @Test mutating func getCandidatesOkTest() async throws {
        let mockGetCandidates = """
[
    {
        "note": "Star new yorkaise de la tv",
        "isFavorite": true,
        "firstName": "Thomas",
        "email": "th.motas@gmail.com",
        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
        "phone": "0988776699",
        "lastName": "Motas",
        "linkedinURL": ""
    },
    {
        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
        "firstName": "Pierre",
        "lastName": "Bro",
        "email": "pierre.brow@gmail.com",
        "phone": "0988776699",
        "isFavorite": false,
        "note": "Un délire ce mec",
        "linkedinURL": ""
    }
]
""".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockGetCandidates)
        }
        
        let candidatesViewModel = CandidatesViewModel(session: session)
        
        await candidatesViewModel.getCandidates()
        #expect(candidatesViewModel.candidats.count == 2)
        #expect(candidatesViewModel.candidats[0].email == "th.motas@gmail.com")
    }

    @Test mutating func removeCandidateOkTest() async throws {
        let mockCandidates = """
[
    {
        "note": "Star new yorkaise de la tv",
        "isFavorite": true,
        "firstName": "Thomas",
        "email": "th.motas@gmail.com",
        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
        "phone": "0988776699",
        "lastName": "Motas",
        "linkedinURL": ""
    },
    {
        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
        "firstName": "Pierre",
        "lastName": "Bro",
        "email": "pierre.brow@gmail.com",
        "phone": "0988776699",
        "isFavorite": false,
        "note": "Un délire ce mec",
        "linkedinURL": ""
    }
]
""".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockCandidates)
        }
        
        let candidatesViewModel = CandidatesViewModel(session: session)
        //fetch candidates
        await candidatesViewModel.getCandidates()
        //want to remove the first candidate
        candidatesViewModel.candidats[0].needToBeDeleted = true
        await candidatesViewModel.removeCandidates()
        #expect(candidatesViewModel.needToPresentAlert == true)
        #expect(candidatesViewModel.alert == .deleteCandidateSuccess(name: candidatesViewModel.candidats[0].firstName + candidatesViewModel.candidats[0].lastName))
    }
    
    @Test mutating func noCandidateToRemoveOkTest() async throws {
        let mockCandidates = """
[
    {
        "note": "Star new yorkaise de la tv",
        "isFavorite": true,
        "firstName": "Thomas",
        "email": "th.motas@gmail.com",
        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
        "phone": "0988776699",
        "lastName": "Motas",
        "linkedinURL": ""
    },
    {
        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
        "firstName": "Pierre",
        "lastName": "Bro",
        "email": "pierre.brow@gmail.com",
        "phone": "0988776699",
        "isFavorite": false,
        "note": "Un délire ce mec",
        "linkedinURL": ""
    }
]
""".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockCandidates)
        }
        
        let candidatesViewModel = CandidatesViewModel(session: session)
        //fetch candidates
        await candidatesViewModel.getCandidates()
        //want to remove the first candidate
        await candidatesViewModel.removeCandidates()
        #expect(candidatesViewModel.needToPresentAlert == false)
    }
    
    @Test mutating func filterFavoriteTest() async throws {
        let mockCandidates = """
[
    {
        "note": "Star new yorkaise de la tv",
        "isFavorite": true,
        "firstName": "Thomas",
        "email": "th.motas@gmail.com",
        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
        "phone": "0988776699",
        "lastName": "Motas",
        "linkedinURL": ""
    },
    {
        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
        "firstName": "Pierre",
        "lastName": "Bro",
        "email": "pierre.brow@gmail.com",
        "phone": "0988776699",
        "isFavorite": false,
        "note": "Un délire ce mec",
        "linkedinURL": ""
    }
]
""".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockCandidates)
        }
        
        let candidatesViewModel = CandidatesViewModel(session: session)
        //fetch candidates
        await candidatesViewModel.getCandidates()
        candidatesViewModel.filterCandidates(with: "favorite")
        #expect(candidatesViewModel.candidats.count == 1)
        #expect(candidatesViewModel.candidats[0].email == "th.motas@gmail.com")
    }
    
    @Test mutating func filterByNameTest() async throws {
        let mockCandidates = """
[
    {
        "note": "Star new yorkaise de la tv",
        "isFavorite": true,
        "firstName": "Thomas",
        "email": "th.motas@gmail.com",
        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
        "phone": "0988776699",
        "lastName": "Motas",
        "linkedinURL": ""
    },
    {
        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
        "firstName": "Pierre",
        "lastName": "Bro",
        "email": "pierre.brow@gmail.com",
        "phone": "0988776699",
        "isFavorite": false,
        "note": "Un délire ce mec",
        "linkedinURL": ""
    }
]
""".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockCandidates)
        }
        
        let candidatesViewModel = CandidatesViewModel(session: session)
        //fetch candidates
        await candidatesViewModel.getCandidates()
        //by firstname
        candidatesViewModel.filterCandidates(with: "Pierr")
        #expect(candidatesViewModel.candidats.count == 1)
        #expect(candidatesViewModel.candidats[0].email == "pierre.brow@gmail.com")
        //by lastname
        candidatesViewModel.filterCandidates(with: "Mot")
        #expect(candidatesViewModel.candidats.count == 1)
        #expect(candidatesViewModel.candidats[0].email == "th.motas@gmail.com")
    }
    
    @Test mutating func selectedCandidateTest() async throws {
        let mockCandidates = """
[
    {
        "note": "Star new yorkaise de la tv",
        "isFavorite": true,
        "firstName": "Thomas",
        "email": "th.motas@gmail.com",
        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
        "phone": "0988776699",
        "lastName": "Motas",
        "linkedinURL": ""
    },
    {
        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
        "firstName": "Pierre",
        "lastName": "Bro",
        "email": "pierre.brow@gmail.com",
        "phone": "0988776699",
        "isFavorite": false,
        "note": "Un délire ce mec",
        "linkedinURL": ""
    }
]
""".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockCandidates)
        }
        
        let candidatesViewModel = CandidatesViewModel(session: session)
        //fetch candidates
        await candidatesViewModel.getCandidates()
        #expect(candidatesViewModel.candidats[0].needToBeDeleted == false)
        candidatesViewModel.selectedCandidate(with: candidatesViewModel.candidats[0])
        #expect(candidatesViewModel.candidats[0].needToBeDeleted == true)
    }
    
    @Test mutating func deleteCandidateNOKTest() async throws {
        let mockCandidates = """
[
    {
        "note": "Star new yorkaise de la tv",
        "isFavorite": true,
        "firstName": "Thomas",
        "email": "th.motas@gmail.com",
        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
        "phone": "0988776699",
        "lastName": "Motas",
        "linkedinURL": ""
    },
    {
        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
        "firstName": "Pierre",
        "lastName": "Bro",
        "email": "pierre.brow@gmail.com",
        "phone": "0988776699",
        "isFavorite": false,
        "note": "Un délire ce mec",
        "linkedinURL": ""
    }
]
""".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockCandidates)
        }
        
        let candidatesViewModel = CandidatesViewModel(session: session)
        //fetch candidates
        await candidatesViewModel.getCandidates()
        candidatesViewModel.candidats[0].needToBeDeleted = true
        candidatesViewModel.candidats[0].id = UUID()
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                           statusCode: 300,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, mockCandidates)
        }
        await candidatesViewModel.removeCandidates()
        #expect(candidatesViewModel.needToPresentAlert == true)
        print(candidatesViewModel.alert)
//        #expect(candidatesViewModel.alert == .)
    }
}