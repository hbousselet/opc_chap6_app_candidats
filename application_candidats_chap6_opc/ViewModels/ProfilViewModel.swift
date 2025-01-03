//
//  ProfilViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

@MainActor
class ProfilViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var isAdmin: Bool
    @Published var alert: CustomErrors?
    @Published var needToPresentAlert = false
    
    var originalCandidateValue: Candidate
    let api: ApiService
    
    init(candidatToShow: Candidate, serviceApi: ApiService? = nil) {
        self.originalCandidateValue = candidatToShow
        self.candidate = candidatToShow
        self.isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
        self.api = serviceApi ?? DefaultApiService(session: .shared)
    }
    
    func updateFavorite(with candidate: Candidate) async {
        let updateFavorite = await api.fetch(endpoint: .updateFavorite(candidate: candidate.id.uuidString), responseType: Candidate.self)

        do {
            let favorite = try updateFavorite.get()
            self.needToPresentAlert = true
            self.alert = .favoriteCandidateSuccess(name: candidate.firstName + candidate.lastName)
            print("Successfully update favorite: \(String(describing: favorite?.isFavorite))")
        } catch {
            print(error)
            self.needToPresentAlert = true
            self.alert = CustomErrors.invalidResponse
        }
    }
    
    func updateCandidateInformations(with candidate: Candidate) async {
        let updateCandidateInformations = await api.fetch(endpoint: .updateCandidate(candidate: candidate.id.uuidString,
                                                                     email: self.candidate.email,
                                                                     note: self.candidate.note,
                                                                     linkedinURL: self.candidate.linkedinURL,
                                                                     firstName: self.candidate.firstName,
                                                                     lastName: self.candidate.lastName,
                                                                     phone: self.candidate.phone),
                                                                     responseType: Candidate.self)
        do {
            let update = try updateCandidateInformations.get()
            self.needToPresentAlert = true
            self.alert = .updateCandidateSuccess
            print("Successfully updated candidate: \(String(describing: update?.firstName))")
        } catch {
            self.candidate = self.originalCandidateValue
            self.alert = .invalidResponse
            self.needToPresentAlert = true
            print(error)
        }
    }
    
    func getCandidate() async {
        let fetchCandidate = await api.fetch(endpoint: .fetchCandidate(candidate: self.candidate.id.uuidString), responseType: Candidate.self)
        do {
            let candidate = try fetchCandidate.get()
            guard let candidate else { return }
            self.candidate = candidate
            print("Successfully fetch the candidate : \(self.candidate.firstName)")
        } catch {
            self.alert = .invalidResponse
            self.needToPresentAlert = true
            print(error)
        }
    }
}
