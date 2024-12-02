//
//  CandidatesView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct CandidatesView: View {
    @State private var searchText: String = ""
    @State private var isFavoriteFilter: Bool = false
    @State private var isEditable: Bool = false
    @State private var circleTapped: Bool = false
    @State private var candidateToRemove: [Candidate] = []
    
    @StateObject var viewModel = CandidatesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.candidats) { candidat in
                HStack {
                    if isEditable {
                        Circle()
                            .fill(candidat.needToBeDeleted ? .black : .white)
                            .stroke(.black, lineWidth: 1)
                            .frame(width: 20, height: 20)
                            .padding(.leading, 10)
                        
                    }
                    NavigationLink("\(candidat.lastName) \(candidat.firstName)") {
                        ProfilView(of: candidat)
                    }
                    .disabled(isEditable)
                    Spacer()
                    Image(systemName: "star")
                        .background(candidat.isFavorite ? Color.black : Color.clear)
                }
                .onTapGesture {
                    viewModel.selectedCandidate(with: candidat)
                    if !candidateToRemove.contains(candidat) {
                        candidateToRemove.append(candidat)
                    }
                }
            }
            .searchable(text: $searchText)
            .listRowSpacing(2)
            .onChange(of: searchText) {
                viewModel.filterCandidates(with: searchText)
                if searchText == "" {
                    viewModel.candidats = viewModel.allCandidates
                }
            }
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
                if isEditable {
                    Button {
                        //action for edit
                        isEditable.toggle()
                    } label: {
                        Text("Cancel")
                    }
                } else {
                    Button {
                        //action for edit
                        isEditable.toggle()
                    } label: {
                        Text("Edit")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if isEditable {
                    Button {
                        isEditable.toggle()
                        // call the delete function
                        Task {
                            await viewModel.removeCandidates(with: candidateToRemove)
                            candidateToRemove.removeAll()
                        }
                    } label: {
                        Text("Delete")
                    }
                } else {
                    Button {
                        isFavoriteFilter.toggle()
                        viewModel.filterCandidates(with: "favorite")
                        if isFavoriteFilter == false {
                            viewModel.candidats = viewModel.allCandidates
                        }
                        
                    } label: {
                        Image(systemName: "star")
                    }
                }
            }
        }
    }
}
