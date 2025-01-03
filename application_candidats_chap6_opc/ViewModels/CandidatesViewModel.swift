//
//  CandidatesViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

@MainActor
class CandidatesViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var alert: CustomErrors?
    @Published var needToPresentAlert = false
    
    var allCandidates: [Candidate] = []
    let api: ApiService
    
    init(serviceApi: ApiService? = nil) {
        self.api = serviceApi ?? DefaultApiService(session: .shared)
    }
    
    func getCandidates() async {
        let fetchCandidates = await api.fetch(endpoint: .fetchCandidates, responseType: [Candidate].self)
        do {
            let candidates = try fetchCandidates.get()
            guard let candidates else { return }
            self.candidates = candidates
            self.allCandidates = self.candidates
        } catch {
            print(error)
            self.needToPresentAlert = true
            self.alert = .invalidResponse
        }
    }
    
    func filterCandidates(with filter: String) {
        switch filter {
        case "favorite":
            self.candidates = allCandidates.filter { $0.isFavorite == true }
        default:
            self.candidates = allCandidates.filter { $0.firstName.lowercased().contains(filter.lowercased()) || $0.lastName.lowercased().contains(filter.lowercased()) }
        }
    }
    
    func deleteCandidates() async {
        //get candidatesId with needToBeDeleted == true
        let candidatesIdToRemove = self.candidates.filter { $0.needToBeDeleted == true }
        
        for candidateToRemove in candidatesIdToRemove {
            let deleteCandidate = await api.fetch(endpoint: .deleteCandidate(candidate: candidateToRemove.id.uuidString), responseType: EmptyResponse.self)
            do {
                let _ = try deleteCandidate.get()
                self.needToPresentAlert = true
                self.alert = .deleteCandidateSuccess(name: candidateToRemove.firstName + candidateToRemove.lastName)
                print("Successfully deleted candidate : \(candidateToRemove)")
            } catch {
                print(error)
                self.needToPresentAlert = true
                self.alert = .invalidResponse
            }
        }
    }
    
    func selectedCandidate(with candidateSelected: Candidate) {
        self.candidates[self.candidates.firstIndex { candid in candid.id == candidateSelected.id }!].needToBeDeleted.toggle()
    }
}

struct Candidate: Decodable, Identifiable, Hashable {
    var phone: String?
    var note: String?
    var id: UUID
    var firstName: String
    var linkedinURL: String?
    var isFavorite: Bool
    var email: String
    var lastName: String
    var needToBeDeleted = false
  
  enum CodingKeys: String, CodingKey {
      case phone
      case note
      case id
      case firstName
      case linkedinURL
      case isFavorite
      case email
      case lastName
      }
}

struct EmptyResponse: Decodable { }
