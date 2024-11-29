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
    @State private var isEditable: Bool = false
    
    init(of candidatToShow: Candidate) {
        model = ProfilViewModel(candidatToShow: candidatToShow)
    }
    
    var body: some View {
        NavigationStack {
            HStack {
//                Text("\(model.candidat.firstName)")
                TextField("\(model.originalCandidateValue.firstName)", text: $model.candidat.firstName)
                    .textFieldStyle(.plain)
                    .border(.black, width: isEditable ? 3 : 0)
                    .disabled(!isEditable)
                Spacer()
                Button {
                    if model.isAdmin {
                        print("tapped")
                        Task {
                            await model.updateFavorite(with: model.candidat.id.uuidString)
                        }
                    }
                } label: {
                    Image(systemName: "star")
                        .foregroundStyle(model.candidat.isFavorite ? Color.clear : Color.black)
                }
            }
            VStack(alignment: .leading) {
                Text(!isEditable ? "Phone \(model.candidat.phone ?? "")" : "Phone")
                if isEditable {
                    TextField("\(model.originalCandidateValue.phone ?? "")", text: Binding(
                        get: { self.model.candidat.phone ?? "" },
                        set: { self.model.candidat.phone = $0 }
                    ))
                        .textFieldStyle(.plain)
                        .border(.black, width: isEditable ? 3 : 0)
                        .disabled(!isEditable)
                }
                Text(!isEditable ? "Email  \(model.candidat.email)" : "Email")
                if isEditable {
                    TextField("\(model.originalCandidateValue.email)", text: $model.candidat.email)
                        .textFieldStyle(.plain)
                        .border(.black, width: isEditable ? 3 : 0)
                        .disabled(!isEditable)
                }
                if isEditable {
                    Text("Linkedin")
                    TextField("\(model.originalCandidateValue.linkedinURL ?? "")", text: Binding(
                        get: { self.model.candidat.linkedinURL ?? "" },
                        set: { self.model.candidat.linkedinURL = $0 }
                    ))
                        .textFieldStyle(.plain)
                        .border(.black, width: isEditable ? 3 : 0)
                        .disabled(!isEditable)
                } else {
                    HStack {
                        Text("Linkedin")
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Go on Linkedin")
                        }
                        
                    }
                }
                VStack(alignment: .leading) {
                    Text("Note")
                    RoundedRectangle(cornerRadius: 12)
                        .opacity(0.2)
                        .overlay {
                            TextField("\(model.originalCandidateValue.note ?? "")", text: Binding(
                                get: { self.model.candidat.note ?? "" },
                                set: { self.model.candidat.note = $0 }
                            ))
                                .textFieldStyle(.plain)
                                .disabled(!isEditable)
                        }
                        .border(.black, width: 3)
                }
                
            }
        }
        .padding(.horizontal, 20)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if isEditable == false {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.blue)
                    }
                } else {
                    Button {
                        isEditable.toggle()
                        model.candidat = model.originalCandidateValue
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if isEditable == false {
                    Button {
                        isEditable.toggle()
                    } label: {
                        Text("Edit")
                    }
                } else {
                    Button {
                        isEditable.toggle()
                        //do the call to update the Candidate
                        Task {
                            await model.updateCandidateInformations(with: model.candidat.id.uuidString)
                        }
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}
