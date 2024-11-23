//
//  ProfilViewModel.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

class ProfilViewModel: ObservableObject {
    @Published var candidat: Candidate
    
    init(candidat: Candidate) {
        self.candidat = candidat
    }
    
}
