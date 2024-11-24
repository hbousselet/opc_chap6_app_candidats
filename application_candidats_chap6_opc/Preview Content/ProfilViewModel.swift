//
//  ProfilViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

class ProfilViewModel: ObservableObject {
    @Published var candidat: Candidate
    @Published var isAdmin: Bool
    var originalCandidateValue: Candidate
    
    init(candidatToShow: Candidate) {
        self.originalCandidateValue = candidatToShow
        self.candidat = candidatToShow
        self.isAdmin = ApiService.isAdmin ?? false
    }
    
    func updateFavorite(with candidateid: String) async {
        do {
            let request = try await ApiService.shared.fetch(endpoint: .put(Route.updateFavorite, candidateid, nil), responseType: Candidate.self)
            switch request {
            case .success(let response):
                print("Successfully update favorite: \(String(describing: response?.isFavorite))")
            case .failure(let error):
                //TO DO - rajouter une alerte
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func updateCandidateInformations(with candidateid: String) async {
        let parameters = ["email": self.candidat.email,
                          "note": self.candidat.note,
                          "linkedinURL": self.candidat.linkedinURL,
                          "firstName": self.candidat.firstName,
                          "lastName": self.candidat.lastName,
                          "phone": self.candidat.phone]
        do {
            let request = try await ApiService.shared.fetch(endpoint: .put(Route.getCandidateById, candidateid, parameters), responseType: Candidate.self)
            switch request {
            case .success(let response):
                print("Successfully updated candidate: \(String(describing: response))")
            case .failure(let error):
                //TO DO - rajouter une alerte
                self.candidat = self.originalCandidateValue
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

//email: String (email)
//note: String?
//linkedinURL: String?
//firstName: String
//lastName: String
//phone: String
