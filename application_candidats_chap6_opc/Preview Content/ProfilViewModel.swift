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
    
    init(candidatToShow: Candidate) {
        self.candidat = candidatToShow
        self.isAdmin = ApiService.isAdmin ?? false
    }
}
