//
//  CandidatesViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

class CandidatesViewModel: ObservableObject {
    @Published var candidats: [Candidate] = []
    @Published var alert: CustomErrors?
    @Published var needToPresentAlert = false
    
    var allCandidates: [Candidate] = []
    let session: URLSession
    
    lazy var api: DefaultApiService = {
        DefaultApiService(session: session)
    }()
    
    init(session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
    }
    
    @MainActor
    func getCandidates() async {
        let request = await api.fetch(endpoint: .fetchCandidates, responseType: [Candidate].self)
        do {
            let candidates = try request.get()
            guard let candidates else { return }
            self.candidats = candidates
            self.allCandidates = self.candidats
            print("Successfully fetch the candidates with first candidats : \(self.candidats[0])")
        } catch {
            print(error)
        }
    }
    
    func filterCandidates(with filter: String) {
        switch filter {
        case "favorite":
            self.candidats = allCandidates.filter { $0.isFavorite == true }
        default:
            self.candidats = allCandidates.filter { $0.firstName.lowercased().contains(filter.lowercased()) || $0.lastName.lowercased().contains(filter.lowercased()) }
        }
    }
    
    @MainActor
    func removeCandidates() async {
        //get candidatesId with needToBeDeleted == true
        let candidatesIdToRemove = self.candidats.filter { $0.needToBeDeleted == true }
        
        for candidateToRemove in candidatesIdToRemove {
            let request = await api.fetch(endpoint: .deleteCandidate(candidate: candidateToRemove.id.uuidString), responseType: EmptyResponse.self)
            do {
                let _ = try request.get()
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
        self.candidats[self.candidats.firstIndex { candid in candid.id == candidateSelected.id }!].needToBeDeleted.toggle()
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
