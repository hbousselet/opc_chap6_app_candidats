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
    
    init() {
        self.session = URLSession.shared
    }
    
    @MainActor
    func getCandidates() async {
        let service = ApiServiceV2(session: session)
        do {
            let request = try await service.fetch(endpoint: .fetchCandidates, responseType: [Candidate].self)
            switch request {
            case .success(let response):
                guard let response else { return }
                self.candidats = response
                self.allCandidates = self.candidats
                print("Successfully fetch the candidates with first candidats : \(self.candidats[0])")
            case .failure(let error):
                //TO DO - rajouter une alerte
                print(error)
            }
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
        
        let service = ApiServiceV2(session: session)

        for candidateToRemove in candidatesIdToRemove {
            do {
                let request = try await service.fetch(endpoint: .deleteCandidate(candidate: candidateToRemove.id.uuidString), responseType: EmptyResponse.self)
                switch request {
                case .success(_):
                    self.needToPresentAlert = true
                    self.alert = .deleteCandidateSuccess(name: candidateToRemove.firstName + candidateToRemove.lastName)
                    print("Successfully deleted candidate : \(candidateToRemove)")
                case .failure(let error):
                    //TO DO - rajouter une alerte
                    print(error)
                }
            } catch {
                print(error)
            }
        }
            await getCandidates()
    }
    
    func selectedCandidate(with candidateSelected: Candidate) {
        self.candidats[self.candidats.firstIndex { candid in candid.id == candidateSelected.id }!].needToBeDeleted.toggle()
    }
}

struct Candidate: Decodable, Identifiable, Hashable {
    var phone: String?
    var note: String?
    let id: UUID
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

// à modifier avec CodingKeys
struct EmptyResponse: Decodable { }
