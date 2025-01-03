//
//  CandidateViewModelTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues BOUSSELET on 15/12/2024.


@testable import application_candidats_chap6_opc
import XCTest

@MainActor
final class CandidatesViewModelTests: XCTestCase {
    var apiWithCandidateType: MockAPIService<[Candidate]>!
    var apiWithEmptyResponseType: MockAPIService<EmptyResponse>!
    
    override func setUp() {
        apiWithCandidateType = MockAPIService()
        apiWithEmptyResponseType = MockAPIService()
    }
    
    func testGetCandidatesOK() async {
        let candidatesInJSON = """
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
        
        guard let candidates = try? JSONDecoder().decode([Candidate].self, from: candidatesInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        apiWithCandidateType.data = candidates
        apiWithCandidateType.error = nil
        apiWithCandidateType.shouldSuccess = true
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithCandidateType)
        
        await candidatesViewModel.getCandidates()
        
        XCTAssertTrue(candidatesViewModel.candidates == candidates)
    }
    
    func testGetCandidatesNOK() async {
        
        apiWithCandidateType.data = nil
        apiWithCandidateType.error = .invalidResponse
        apiWithCandidateType.shouldSuccess = false
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithCandidateType)
        
        await candidatesViewModel.getCandidates()
        
        XCTAssertTrue(candidatesViewModel.needToPresentAlert)
        XCTAssert(candidatesViewModel.alert == .invalidResponse)
    }
    
    func testFilterByFavorite() {
        let candidatesInJSON = """
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
        
        guard let candidates = try? JSONDecoder().decode([Candidate].self, from: candidatesInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        apiWithCandidateType.data = nil
        apiWithCandidateType.error = nil
        apiWithCandidateType.shouldSuccess = true
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithCandidateType)
        candidatesViewModel.allCandidates = candidates
        
        candidatesViewModel.filterCandidates(with: "favorite")
        XCTAssert(candidatesViewModel.candidates.count == 1)
        XCTAssert(candidatesViewModel.candidates[0].email == "th.motas@gmail.com")
    }
    
    func testFilterByFirsname() {
        // GIVEN
        let candidatesInJSON = """
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
        
        guard let candidates = try? JSONDecoder().decode([Candidate].self, from: candidatesInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        apiWithCandidateType.data = nil
        apiWithCandidateType.error = nil
        apiWithCandidateType.shouldSuccess = true
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithCandidateType)
        candidatesViewModel.allCandidates = candidates
        let firstNamePattern = String(candidates[0].firstName.prefix(2))
        
        //WHEN
        candidatesViewModel.filterCandidates(with: firstNamePattern)
        
        // THEN
        XCTAssert(candidatesViewModel.candidates.count == 1)
        XCTAssert(candidatesViewModel.candidates[0] == candidates.first)
    }
    
    func testFilterByLastname() {
        // GIVEN
        let candidatesInJSON = """
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
                "lastName": "Browarskoi",
                "email": "pierre.brow@gmail.com",
                "phone": "0988776699",
                "isFavorite": false,
                "note": "Un délire ce mec",
                "linkedinURL": ""
            }
        ]
""".data(using: .utf8)!
        
        guard let candidates = try? JSONDecoder().decode([Candidate].self, from: candidatesInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        apiWithCandidateType.data = nil
        apiWithCandidateType.error = nil
        apiWithCandidateType.shouldSuccess = true
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithCandidateType)
        candidatesViewModel.allCandidates = candidates
        let firstNamePattern = String(candidates[1].lastName.prefix(3))
        
        //WHEN
        candidatesViewModel.filterCandidates(with: firstNamePattern)
        
        // THEN
        XCTAssert(candidatesViewModel.candidates.count == 1)
        XCTAssert(candidatesViewModel.candidates[0] == candidates.last)
    }
    
    func testSelectCandidateForDeletion() {
        // GIVEN
        let candidatesInJSON = """
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
                "lastName": "Browarskoi",
                "email": "pierre.brow@gmail.com",
                "phone": "0988776699",
                "isFavorite": false,
                "note": "Un délire ce mec",
                "linkedinURL": ""
            }
        ]
""".data(using: .utf8)!
        
        guard let candidates = try? JSONDecoder().decode([Candidate].self, from: candidatesInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        apiWithCandidateType.data = nil
        apiWithCandidateType.error = nil
        apiWithCandidateType.shouldSuccess = true
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithCandidateType)
        candidatesViewModel.allCandidates = candidates
        candidatesViewModel.candidates = candidates
        
        //WHEN
        candidatesViewModel.selectedCandidate(with: candidates.first!)
        
        // THEN
        XCTAssertTrue(candidatesViewModel.candidates[0].needToBeDeleted)
        XCTAssertFalse(candidatesViewModel.candidates[1].needToBeDeleted)
    }
    
    func testDeleteCandidateOk() async {
        // GIVEN
        let candidatesInJSON = """
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
        
        guard let candidates = try? JSONDecoder().decode([Candidate].self, from: candidatesInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        apiWithEmptyResponseType.data = EmptyResponse()
        apiWithEmptyResponseType.error = nil
        apiWithEmptyResponseType.shouldSuccess = true
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithEmptyResponseType)
        candidatesViewModel.candidates = candidates
        
        // WHEN
        let candidateToRemove = candidates.first!
        candidatesViewModel.selectedCandidate(with: candidateToRemove)  // want to remove first candidate
        await candidatesViewModel.deleteCandidates()
        
        //THEN
        XCTAssertTrue(candidatesViewModel.needToPresentAlert)
        XCTAssert(candidatesViewModel.alert == .deleteCandidateSuccess(name: candidateToRemove.firstName + candidateToRemove.lastName))

    }
    
    func testDeleteCandidateNOk() async {
        // GIVEN
        let candidatesInJSON = """
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
        
        guard let candidates = try? JSONDecoder().decode([Candidate].self, from: candidatesInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        apiWithEmptyResponseType.data = nil
        apiWithEmptyResponseType.error = .invalidResponse
        apiWithEmptyResponseType.shouldSuccess = false
        
        let candidatesViewModel = CandidatesViewModel(serviceApi: apiWithEmptyResponseType)
        candidatesViewModel.candidates = candidates
        
        // WHEN
        let candidateToRemove = candidates.first!
        candidatesViewModel.selectedCandidate(with: candidateToRemove)  // want to remove first candidate
        await candidatesViewModel.deleteCandidates()
        
        //THEN
        XCTAssertTrue(candidatesViewModel.needToPresentAlert)
        XCTAssert(candidatesViewModel.alert == .invalidResponse)

    }
}



//@testable import application_candidats_chap6_opc
//import Testing
//import Foundation
//
//struct CandidateViewModelTests {
//    
//    //utiliser la méthode setup de l'autre lib
//    // renommer les noms des mocks
//    // mettre la logique given when then => https://martinfowler.com/bliki/GivenWhenThen.html
//
//    @Test func getCandidatesOkTest() async {
//        
//        lazy var session: URLSession = {
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.protocolClasses = [MockURLSessionProtocol.self]
//            return URLSession(configuration: configuration)
//        }()
//        
//        let mockGetCandidates = """
//[
//    {
//        "note": "Star new yorkaise de la tv",
//        "isFavorite": true,
//        "firstName": "Thomas",
//        "email": "th.motas@gmail.com",
//        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
//        "phone": "0988776699",
//        "lastName": "Motas",
//        "linkedinURL": ""
//    },
//    {
//        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
//        "firstName": "Pierre",
//        "lastName": "Bro",
//        "email": "pierre.brow@gmail.com",
//        "phone": "0988776699",
//        "isFavorite": false,
//        "note": "Un délire ce mec",
//        "linkedinURL": ""
//    }
//]
//""".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockGetCandidates)
//        }
//        
//        let candidatesViewModel = CandidatesViewModel(session: session)
//        
//        await candidatesViewModel.getCandidates()
//        #expect(candidatesViewModel.candidats.count == 2)
//        #expect(candidatesViewModel.candidats[0].email == "th.motas@gmail.com")
//    }
//
//    @Test func removeCandidateOkTest() async {
//        
//        lazy var session: URLSession = {
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.protocolClasses = [MockURLSessionProtocol.self]
//            return URLSession(configuration: configuration)
//        }()
//        
//        let mockCandidates = """
//[
//    {
//        "note": "Star new yorkaise de la tv",
//        "isFavorite": true,
//        "firstName": "Thomas",
//        "email": "th.motas@gmail.com",
//        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
//        "phone": "0988776699",
//        "lastName": "Motas",
//        "linkedinURL": ""
//    },
//    {
//        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
//        "firstName": "Pierre",
//        "lastName": "Bro",
//        "email": "pierre.brow@gmail.com",
//        "phone": "0988776699",
//        "isFavorite": false,
//        "note": "Un délire ce mec",
//        "linkedinURL": ""
//    }
//]
//""".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockCandidates)
//        }
//        
//        let candidatesViewModel = CandidatesViewModel(session: session)
//        //fetch candidates
//        await candidatesViewModel.getCandidates()
//        //want to remove the first candidate
//        candidatesViewModel.candidats[0].needToBeDeleted = true
//        await candidatesViewModel.removeCandidates()
//        #expect(candidatesViewModel.needToPresentAlert == true)
//        #expect(candidatesViewModel.alert == .deleteCandidateSuccess(name: candidatesViewModel.candidats[0].firstName + candidatesViewModel.candidats[0].lastName))
//    }
//    
//    @Test func noCandidateToRemoveOkTest() async {
//        
//        lazy var session: URLSession = {
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.protocolClasses = [MockURLSessionProtocol.self]
//            return URLSession(configuration: configuration)
//        }()
//        
//        let mockCandidates = """
//[
//    {
//        "note": "Star new yorkaise de la tv",
//        "isFavorite": true,
//        "firstName": "Thomas",
//        "email": "th.motas@gmail.com",
//        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
//        "phone": "0988776699",
//        "lastName": "Motas",
//        "linkedinURL": ""
//    },
//    {
//        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
//        "firstName": "Pierre",
//        "lastName": "Bro",
//        "email": "pierre.brow@gmail.com",
//        "phone": "0988776699",
//        "isFavorite": false,
//        "note": "Un délire ce mec",
//        "linkedinURL": ""
//    }
//]
//""".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockCandidates)
//        }
//        
//        let candidatesViewModel = CandidatesViewModel(session: session)
//        //fetch candidates
//        await candidatesViewModel.getCandidates()
//        //want to remove the first candidate
//        await candidatesViewModel.removeCandidates()
//        #expect(candidatesViewModel.needToPresentAlert == false)
//    }
//    
//    @Test func filterFavoriteTest() async {
//        
//        lazy var session: URLSession = {
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.protocolClasses = [MockURLSessionProtocol.self]
//            return URLSession(configuration: configuration)
//        }()
//        
//        let mockCandidates = """
//[
//    {
//        "note": "Star new yorkaise de la tv",
//        "isFavorite": true,
//        "firstName": "Thomas",
//        "email": "th.motas@gmail.com",
//        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
//        "phone": "0988776699",
//        "lastName": "Motas",
//        "linkedinURL": ""
//    },
//    {
//        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
//        "firstName": "Pierre",
//        "lastName": "Bro",
//        "email": "pierre.brow@gmail.com",
//        "phone": "0988776699",
//        "isFavorite": false,
//        "note": "Un délire ce mec",
//        "linkedinURL": ""
//    }
//]
//""".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockCandidates)
//        }
//        
//        let candidatesViewModel = CandidatesViewModel(session: session)
//        //fetch candidates
//        await candidatesViewModel.getCandidates()
//        candidatesViewModel.filterCandidates(with: "favorite")
//        #expect(candidatesViewModel.candidats.count == 1)
//        #expect(candidatesViewModel.candidats[0].email == "th.motas@gmail.com")
//    }
//    
//    @Test func filterByNameTest() async {
//        
//        lazy var session: URLSession = {
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.protocolClasses = [MockURLSessionProtocol.self]
//            return URLSession(configuration: configuration)
//        }()
//        
//        let mockCandidates = """
//[
//    {
//        "note": "Star new yorkaise de la tv",
//        "isFavorite": true,
//        "firstName": "Thomas",
//        "email": "th.motas@gmail.com",
//        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
//        "phone": "0988776699",
//        "lastName": "Motas",
//        "linkedinURL": ""
//    },
//    {
//        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
//        "firstName": "Pierre",
//        "lastName": "Bro",
//        "email": "pierre.brow@gmail.com",
//        "phone": "0988776699",
//        "isFavorite": false,
//        "note": "Un délire ce mec",
//        "linkedinURL": ""
//    }
//]
//""".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockCandidates)
//        }
//        
//        let candidatesViewModel = CandidatesViewModel(session: session)
//        //fetch candidates
//        await candidatesViewModel.getCandidates()
//        //by firstname
//        candidatesViewModel.filterCandidates(with: "Pierr")
//        #expect(candidatesViewModel.candidats.count == 1)
//        #expect(candidatesViewModel.candidats[0].email == "pierre.brow@gmail.com")
//        //by lastname
//        candidatesViewModel.filterCandidates(with: "Mot")
//        #expect(candidatesViewModel.candidats.count == 1)
//        #expect(candidatesViewModel.candidats[0].email == "th.motas@gmail.com")
//    }
//    
//    @Test func selectedCandidateTest() async {
//        
//            lazy var session: URLSession = {
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.protocolClasses = [MockURLSessionProtocol.self]
//            return URLSession(configuration: configuration)
//        }()
//        
//        let mockCandidates = """
//[
//    {
//        "note": "Star new yorkaise de la tv",
//        "isFavorite": true,
//        "firstName": "Thomas",
//        "email": "th.motas@gmail.com",
//        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
//        "phone": "0988776699",
//        "lastName": "Motas",
//        "linkedinURL": ""
//    },
//    {
//        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
//        "firstName": "Pierre",
//        "lastName": "Bro",
//        "email": "pierre.brow@gmail.com",
//        "phone": "0988776699",
//        "isFavorite": false,
//        "note": "Un délire ce mec",
//        "linkedinURL": ""
//    }
//]
//""".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockCandidates)
//        }
//        
//        let candidatesViewModel = CandidatesViewModel(session: session)
//        //fetch candidates
//        await candidatesViewModel.getCandidates()
//        #expect(candidatesViewModel.candidats[0].needToBeDeleted == false)
//        candidatesViewModel.selectedCandidate(with: candidatesViewModel.candidats[0])
//        #expect(candidatesViewModel.candidats[0].needToBeDeleted == true)
//    }
//    
//    @Test func deleteCandidateNOKTest() async {
//        
//        lazy var session: URLSession = {
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.protocolClasses = [MockURLSessionProtocol.self]
//            return URLSession(configuration: configuration)
//        }()
//        
//        let mockCandidates = """
//[
//    {
//        "note": "Star new yorkaise de la tv",
//        "isFavorite": true,
//        "firstName": "Thomas",
//        "email": "th.motas@gmail.com",
//        "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
//        "phone": "0988776699",
//        "lastName": "Motas",
//        "linkedinURL": ""
//    },
//    {
//        "id": "78940918-E5E7-48CF-B072-2245098DDAA0",
//        "firstName": "Pierre",
//        "lastName": "Bro",
//        "email": "pierre.brow@gmail.com",
//        "phone": "0988776699",
//        "isFavorite": false,
//        "note": "Un délire ce mec",
//        "linkedinURL": ""
//    }
//]
//""".data(using: .utf8)!
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockCandidates)
//        }
//        
//        let candidatesViewModel = CandidatesViewModel(session: session)
//        //fetch candidates
//        await candidatesViewModel.getCandidates()
//        candidatesViewModel.candidats[0].needToBeDeleted = true
//        candidatesViewModel.candidats[0].id = UUID()
//        
//        MockURLSessionProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
//                                           statusCode: 300,
//                                           httpVersion: nil,
//                                           headerFields: [:])!
//            return (response, mockCandidates)
//        }
//        await candidatesViewModel.removeCandidates()
//        #expect(candidatesViewModel.needToPresentAlert == true)
//        print(candidatesViewModel.alert)
////        #expect(candidatesViewModel.alert == .)
//    }
//}
