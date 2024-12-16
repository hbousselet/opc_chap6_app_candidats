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
    
    lazy var api: ApiService = {
        ApiService(session: session)
    }()
    
    init(candidatToShow: Candidate, session: URLSession? = nil) {
        self.originalCandidateValue = candidatToShow
        self.candidate = candidatToShow
        self.isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
        self.session = session ?? URLSession.shared
    }
    
    @MainActor
    func updateFavorite(with candidate: Candidate) async {
        
        let request = await api.fetch(endpoint: .updateFavorite(candidate: candidate.id.uuidString), responseType: Candidate.self)

        do {
            let favorite = try request.get()
            self.needToPresentAlert = true
            self.alert = .favoriteCandidateSuccess(name: candidate.firstName + candidate.lastName)
            print("Successfully update favorite: \(String(describing: favorite?.isFavorite))")
        } catch {
            //TO DO - rajouter une alerte
            print(error)
        }
    }
    
    @MainActor
    func updateCandidateInformations(with candidate: Candidate) async {
        let request = await api.fetch(endpoint: .updateCandidate(candidate: candidate.id.uuidString,
                                                                     email: self.candidate.email,
                                                                     note: self.candidate.note,
                                                                     linkedinURL: self.candidate.linkedinURL,
                                                                     firstName: self.candidate.firstName,
                                                                     lastName: self.candidate.lastName,
                                                                     phone: self.candidate.phone),
                                                                     responseType: Candidate.self)
        do {
            let update = try request.get()
            self.needToPresentAlert = true
            self.alert = .updateCandidateSuccess
            print("Successfully updated candidate: \(String(describing: update?.firstName))")
        } catch {
            //TO DO - rajouter une alerte
            self.candidate = self.originalCandidateValue
            print(error)
        }
    }
    
    @MainActor
    func getCandidate() async {
        let request = await api.fetch(endpoint: .fetchCandidate(candidate: self.candidate.id.uuidString), responseType: Candidate.self)
        do {
            let candidate = try request.get()
            guard let candidate else { return }
            self.candidate = candidate
            print("Successfully fetch the candidate : \(self.candidate.firstName)")
        } catch {
            //TO DO - rajouter une alerte
            print(error)
        }
    }
}
