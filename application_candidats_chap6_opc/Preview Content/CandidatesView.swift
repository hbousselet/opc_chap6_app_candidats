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
                HStack {
                    NavigationLink(candidat.lastName) {
                        ProfilView(of: candidat)
                    }
                    Spacer()
                    Image(systemName: "star")
                        .background(candidat.isFavorite ? Color.black : Color.clear)
                }
            }
            .searchable(text: $searchText)
            .listRowSpacing(2)
        }
        .onAppear {
            Task {
                await viewModel.getCandidates()
            }
        }
        .navigationTitle("Candidats")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    //action for edit
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
