//
//  ProfilView.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

struct ProfilView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var model: ProfilViewModel
    
    init(of candidatToShow: Candidate) {
        model = ProfilViewModel(candidatToShow: candidatToShow)
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("\(model.candidat.firstName)")
                Spacer()
                Button {
                    if model.isAdmin {
                        print("tapped")
                    }
                } label: {
                    Image(systemName: "star")
                        .foregroundStyle(model.candidat.isFavorite ? Color.clear : Color.black)
                }
            }
            VStack(alignment: .leading) {
                Text("Phone \(model.candidat.phone ?? "")")
                Text("Email  \(model.candidat.email)")
                HStack {
                    Text("Linkedin")
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Go on Linkedin")
                    }
                }
                if let note = model.candidat.note {
                    VStack(alignment: .leading) {
                        Text("Note")
                        RoundedRectangle(cornerRadius: 12)
                            .opacity(0.2)
                            .overlay {
                                Text(note)
                            }
                            .border(.black, width: 2)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.blue)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}
