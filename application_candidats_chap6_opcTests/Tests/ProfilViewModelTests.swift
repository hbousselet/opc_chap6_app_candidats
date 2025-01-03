//
//  ProfilViewModelTests.swift
//  application_candidats_chap6_opcTests
//
//  Created by Hugues BOUSSELET on 16/12/2024.
//
@testable import application_candidats_chap6_opc
import XCTest

@MainActor
final class ProfilViewModelTests: XCTestCase {
    var api: MockAPIService<Candidate>!
    
    override func setUp() {
        api = MockAPIService()
    }
    
    func testGetCandidateOK() async {
        //GIVEN
        let candidateInJSON = """
            {
                "note": "Star new yorkaise de la tv",
                "isFavorite": true,
                "firstName": "Thomas",
                "email": "th.motas@gmail.com",
                "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
                "phone": "0988776699",
                "lastName": "Motas",
                "linkedinURL": ""
            }
            """.data(using: .utf8)!
        
        guard let candidate = try? JSONDecoder().decode(Candidate.self, from: candidateInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        api.data = candidate
        api.error = nil
        api.shouldSuccess = true
        
        //WHEN
        let profilViewModel = ProfilViewModel(candidatToShow: candidate, serviceApi: api)
        await profilViewModel.getCandidate()
        
        XCTAssertTrue(profilViewModel.candidate == candidate)
    }
    
    func testGetCandidatesNOK() async {
        //GIVEN
        let candidateInJSON = """
            {
                "note": "Star new yorkaise de la tv",
                "isFavorite": true,
                "firstName": "Thomas",
                "email": "th.motas@gmail.com",
                "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
                "phone": "0988776699",
                "lastName": "Motas",
                "linkedinURL": ""
            }
            """.data(using: .utf8)!
        
        guard let candidate = try? JSONDecoder().decode(Candidate.self, from: candidateInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        api.data = nil
        api.error = .invalidResponse
        api.shouldSuccess = false
        
        //WHEN
        let profilViewModel = ProfilViewModel(candidatToShow: candidate, serviceApi: api)
        await profilViewModel.getCandidate()
        
        XCTAssertTrue(profilViewModel.needToPresentAlert)
        XCTAssert(profilViewModel.alert == .invalidResponse)
    }
    
    func testUpdateFavoriteOK() async {
        //GIVEN
        let candidateInJSON = """
            {
                "note": "Star new yorkaise de la tv",
                "isFavorite": true,
                "firstName": "Thomas",
                "email": "th.motas@gmail.com",
                "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
                "phone": "0988776699",
                "lastName": "Motas",
                "linkedinURL": ""
            }
            """.data(using: .utf8)!
        
        guard let candidate = try? JSONDecoder().decode(Candidate.self, from: candidateInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        api.data = candidate
        api.error = nil
        api.shouldSuccess = true
        
        //WHEN
        let profilViewModel = ProfilViewModel(candidatToShow: candidate, serviceApi: api)
        await profilViewModel.updateFavorite(with: candidate)
        
        //THEN
        XCTAssertTrue(profilViewModel.needToPresentAlert)
        XCTAssert(profilViewModel.alert == .favoriteCandidateSuccess(name: candidate.firstName + candidate.lastName))
    }
    
    func testUpdateFavoriteNOK() async {
        //GIVEN
        let candidateInJSON = """
            {
                "note": "Star new yorkaise de la tv",
                "isFavorite": true,
                "firstName": "Thomas",
                "email": "th.motas@gmail.com",
                "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
                "phone": "0988776699",
                "lastName": "Motas",
                "linkedinURL": ""
            }
            """.data(using: .utf8)!
        
        guard let candidate = try? JSONDecoder().decode(Candidate.self, from: candidateInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        api.data = nil
        api.error = .invalidResponse
        api.shouldSuccess = false
        
        //WHEN
        let profilViewModel = ProfilViewModel(candidatToShow: candidate, serviceApi: api)
        await profilViewModel.updateFavorite(with: candidate)
        
        //THEN
        XCTAssertTrue(profilViewModel.needToPresentAlert)
        XCTAssert(profilViewModel.alert == .invalidResponse)
    }
    
    func testUpdateCandifateInfoOK() async {
        //GIVEN
        let candidateInJSON = """
            {
                "note": "Star new yorkaise de la tv",
                "isFavorite": true,
                "firstName": "Thomas",
                "email": "th.motas@gmail.com",
                "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
                "phone": "0988776699",
                "lastName": "Motas",
                "linkedinURL": ""
            }
            """.data(using: .utf8)!
        
        guard var candidate = try? JSONDecoder().decode(Candidate.self, from: candidateInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        api.data = candidate
        api.error = nil
        api.shouldSuccess = true
        
        candidate.email = "bao@manger.com"
        
        //WHEN
        let profilViewModel = ProfilViewModel(candidatToShow: candidate, serviceApi: api)
        await profilViewModel.updateCandidateInformations(with: candidate)
        
        //THEN
        XCTAssertTrue(profilViewModel.needToPresentAlert)
        XCTAssert(profilViewModel.alert == .updateCandidateSuccess)
    }
    
    func testUpdateCandifateInfoNOK() async {
        //GIVEN
        let candidateInJSON = """
            {
                "note": "Star new yorkaise de la tv",
                "isFavorite": true,
                "firstName": "Thomas",
                "email": "th.motas@gmail.com",
                "id": "3EB598F1-1FDA-4644-B957-57F595CA8094",
                "phone": "0988776699",
                "lastName": "Motas",
                "linkedinURL": ""
            }
            """.data(using: .utf8)!
        
        guard var candidate = try? JSONDecoder().decode(Candidate.self, from: candidateInJSON) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        api.data = nil
        api.error = .invalidResponse
        api.shouldSuccess = false
        
        candidate.email = "bao@manger.com"
        
        //WHEN
        let profilViewModel = ProfilViewModel(candidatToShow: candidate, serviceApi: api)
        await profilViewModel.updateCandidateInformations(with: candidate)
        
        //THEN
        XCTAssertTrue(profilViewModel.needToPresentAlert)
        XCTAssert(profilViewModel.alert == .invalidResponse)
    }
}
