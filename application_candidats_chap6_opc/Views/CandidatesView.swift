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
                            .onTapGesture {
                                viewModel.selectedCandidate(with: candidat)
                            }
                    }
                    NavigationLink("\(candidat.lastName) \(candidat.firstName)") {
                        ProfilView(of: candidat)
                    }
                    .buttonStyle(PlainButtonStyle())
                    //ou ici
                    .disabled(isEditable)
                    Spacer()
                    if candidat.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.black)
                    } else {
                        Image(systemName: "star")
                            .foregroundStyle(.black)
                    }
                }
            }
            .searchable(text: $searchText)
            .listRowSpacing(2)
            .listStyle(PlainListStyle())
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
                            await viewModel.removeCandidates()
                        }
                    } label: {
                        Text("Delete")
                    }
                    .alert(isPresented: $viewModel.needToPresentAlert) {
                        Alert(
                            title: Text("Alert !"),
                            message: Text("\(String(describing: viewModel.alert?.description ?? "chc"))"),
                            dismissButton: .destructive(Text("Exit")))
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
