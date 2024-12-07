//
//  ProfilViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

class ProfilViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var isAdmin: Bool
    @Published var alert: CustomErrors?
    @Published var needToPresentAlert = false
    
    var originalCandidateValue: Candidate
    let session: URLSession
    
    init(candidatToShow: Candidate) {
        self.originalCandidateValue = candidatToShow
        self.candidate = candidatToShow
        self.isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
        self.session = URLSession.shared
    }
    
    @MainActor
    func updateFavorite(with candidate: Candidate) async {
        let service = ApiServiceV2(session: session)
        do {
            let request = try await service.fetch(endpoint: .updateFavorite(candidate: candidate.id.uuidString), responseType: Candidate.self)
            switch request {
            case .success(let response):
                self.needToPresentAlert = true
                self.alert = .favoriteCandidateSuccess(name: candidate.firstName + candidate.lastName)
                print("Successfully update favorite: \(String(describing: response?.isFavorite))")
            case .failure(let error):
                //TO DO - rajouter une alerte
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func updateCandidateInformations(with candidate: Candidate) async {
        let parameters = ["email": self.candidate.email,
                          "note": self.candidate.note,
                          "linkedinURL": self.candidate.linkedinURL,
                          "firstName": self.candidate.firstName,
                          "lastName": self.candidate.lastName,
                          "phone": self.candidate.phone]
        let service = ApiServiceV2(session: session)

        do {
            let request = try await service.fetch(endpoint: .updateCandidate(candidate: candidate.id.uuidString), parametersBody: parameters as [String : Any], responseType: Candidate.self)
            switch request {
            case .success(let response):
                self.needToPresentAlert = true
                self.alert = .updateCandidateSuccess
                print("Successfully updated candidate: \(String(describing: response))")
            case .failure(let error):
                //TO DO - rajouter une alerte
                self.candidate = self.originalCandidateValue
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
