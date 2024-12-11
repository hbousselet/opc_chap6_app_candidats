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
            ScrollView {
                HStack {
                    let lastnameCandidateArranged = model.originalCandidateValue.lastName.first?.uppercased() ?? ""
                    Text("\(model.originalCandidateValue.firstName) \(lastnameCandidateArranged).")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.top)
                    Spacer()
                    Button {
                        if model.isAdmin {
                            Task {
                                await model.updateFavorite(with: model.candidate)
                            }
                        }
                    } label: {
                        Image(systemName: "star.fill").foregroundStyle(.black)
                    }
                    .alert(isPresented: $model.needToPresentAlert) {
                        Alert(
                            title: Text("Alert !"),
                            message: Text("\(String(describing: model.alert?.description ?? "chc"))"),
                            dismissButton: .destructive(Text("Exit")))
                    }
                }
                .padding(.top)
                VStack(alignment: .leading) {
                    Text(!isEditable ? "Phone \(model.candidate.phone ?? "")" : "Phone")
                        .font(.system(size: 22, weight: .bold))
                    if isEditable {
                        TextField("\(model.originalCandidateValue.phone ?? "")", text: Binding(
                            get: { self.model.candidate.phone ?? "" },
                            set: { self.model.candidate.phone = $0 }
                        ))
                        .textFieldStyle(.plain)
                        .border(.black, width: isEditable ? 3 : 0)
                        .disabled(!isEditable)
                        .padding(.top, 25)
                    }
                    Text(!isEditable ? "Email   \(model.candidate.email)" : "Email")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.top, 25)
                    if isEditable {
                        TextField("\(model.originalCandidateValue.email)", text: $model.candidate.email)
                            .textFieldStyle(.plain)
                            .border(.black, width: isEditable ? 3 : 0)
                            .disabled(!isEditable)
                            .padding(.top, 25)
                    }
                    if isEditable {
                        Text("Linkedin")
                            .font(.system(size: 22, weight: .bold))
                        TextField("\(model.originalCandidateValue.linkedinURL ?? "")", text: Binding(
                            get: { self.model.candidate.linkedinURL ?? "" },
                            set: { self.model.candidate.linkedinURL = $0 }
                        ))
                        .textFieldStyle(.plain)
                        .border(.black, width: isEditable ? 3 : 0)
                        .disabled(!isEditable)
                        .padding(.top, 10)
                    } else {
                        HStack {
                            Text("Linkedin")
                                .font(.system(size: 22, weight: .bold))
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("Go on Linkedin")
                            }
                        }
                        .padding(.top, 25)
                    }
                    VStack(alignment: .leading) {
                        Text("Note")
                            .font(.system(size: 22, weight: .bold))
                        TextField("\(model.originalCandidateValue.note ?? "")", text: Binding(
                            get: { self.model.candidate.note ?? "" },
                            set: { self.model.candidate.note = $0 }
                        ))
                        .textFieldStyle(.plain)
                        .disabled(!isEditable)
                        .cornerRadius(10)
                        .background(.white)
                        .overlay (
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 1)
                                .opacity(0.2)
                        )
                    }
                    .padding(.top, 25)
                    
                }
                .padding(.top, 20)
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
                        model.candidate = model.originalCandidateValue
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
                            await model.updateCandidateInformations(with: model.candidate)
                        }
                    } label: {
                        Text("Done")
                    }
                    .alert(isPresented: $model.needToPresentAlert) {
                        Alert(
                            title: Text("Alert !"),
                            message: Text("\(String(describing: model.alert?.description ?? "chc"))"),
                            dismissButton: .destructive(Text("Exit")))
                    }
                }
            }
        }
    }
}
