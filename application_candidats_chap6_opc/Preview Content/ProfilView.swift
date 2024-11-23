//
//  ProfilView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct ProfilView: View {
    @ObservedObject var model: ProfilViewModel
    
    init(candidat: Candidate) {
        model = ProfilViewModel(candidat: candidat)
    }
    
    var body: some View {
        Text("Hello: \(model.candidat.email)")
    }
}
