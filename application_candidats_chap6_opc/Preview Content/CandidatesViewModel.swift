//
//  CandidatesViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

class CandidatesViewModel: ObservableObject {
    @Published var candidats: [Candidate] = []
    var allCandidates: [Candidate] = []
    
    @MainActor
    func getCandidates() async {
        do {
            let request = try await ApiService.shared.fetch(endpoint: .get(Route.getCandidatesList, ""), responseType: [Candidate].self)
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
}
