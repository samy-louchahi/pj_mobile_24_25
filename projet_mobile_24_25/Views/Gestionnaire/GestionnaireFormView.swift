//
//  GestionnaireFormView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 22/03/2025.
//


import SwiftUI

struct GestionnaireFormView: View {
    @ObservedObject var viewModel: GestionnaireViewModel
    var isEditing: Bool
    var existingGestionnaire: Gestionnaire?
    var onDismiss: () -> Void
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack{
                Section(header: Text("Informations")) {
                    TextField("Nom d'utilisateur", text: $username)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    SecureField("Mot de passe", text: $password)
                        .overlay(
                            Group {
                                if isEditing && password.isEmpty {
                                    Text("Laisser vide pour ne pas changer")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                        .offset(y: 2)
                                }
                            },
                            alignment: .leading
                        )
                }
                
                Section {
                    Button("Valider") {
                        Task {
                            if isEditing, let gestionnaire = existingGestionnaire {
                                let partial = PartialGestionnaire(
                                    username: username,
                                    email: email,
                                    password: password.isEmpty ? nil : password,
                                    updatedAt: nil
                                )
                                await viewModel.updateGestionnaire(id: gestionnaire.id, data: partial)
                            } else {
                                let create = GestionnaireCreate(username: username, email: email, password: password,createdAt:"" , updatedAt: "")
                                await viewModel.createGestionnaire(create)
                            }
                            onDismiss()
                        }
                        
                        Button("Annuler") {
                            onDismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle(isEditing ? "Modifier" : "Ajouter")
                .onAppear {
                    if let gestionnaire = existingGestionnaire {
                        username = gestionnaire.username
                        email = gestionnaire.email
                        password = ""
                    }
                }
            }
        }
    }
}
