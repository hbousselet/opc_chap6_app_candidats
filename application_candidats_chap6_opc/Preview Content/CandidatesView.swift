//
//  CandidatesView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct CandidatesView: View {
    @State private var searchText: String = ""
    //pourquoi stateObject et pas Observed object ici ??????
    @StateObject var viewModel = CandidatesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.candidats) { candidat in
                NavigationLink(candidat.lastName, value: candidat)
            }
            .navigationDestination(for: Candidate.self) { candidat in
                ProfilView(candidat: candidat)
            }
        }
        .onAppear {
            Task {
                await viewModel.getCandidates()
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Candidats")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Text("Edit")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "star")
                }
            }
        }
    }
}
