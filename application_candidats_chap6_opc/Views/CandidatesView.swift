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
            List(viewModel.candidates) { candidat in
                HStack {
                    if isEditable {
                        Circle()
                            .fill(candidat.needToBeDeleted ? .black : .white)
                            .stroke(.black, lineWidth: 1)
                            .frame(width: 20, height: 20)
                            .padding(.leading, 0)
                            .onTapGesture {
                                viewModel.selectedCandidate(with: candidat)
                            }
                    }
                    let lastname = candidat.lastName.first?.uppercased() ?? ""
                    Text("\(candidat.firstName) \(lastname).")
                        .overlay(
                            NavigationLink {
                                ProfilView(of: candidat)
                            } label: {
                                EmptyView()
                                    .frame(width: 0, height: 0)
                            }.opacity(0)
                        )
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
                .padding(.horizontal, 2)
            }
            .listRowSeparator(.hidden)
            .listRowSpacing(8.0)
//            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                viewModel.filterCandidates(with: searchText)
                if searchText == "" {
                    viewModel.candidates = viewModel.allCandidates
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getCandidates()
            }
        }
        .refreshable {
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
                        isEditable.toggle()
                    } label: {
                        Text("Cancel")
                    }
                } else {
                    Button {
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
                            await viewModel.deleteCandidates()
                            await viewModel.getCandidates()
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
                            viewModel.candidates = viewModel.allCandidates
                        }
                        
                    } label: {
                        Image(systemName: "star")
                    }
                }
            }
        }
    }
}
