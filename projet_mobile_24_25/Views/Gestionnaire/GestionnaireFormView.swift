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
            ScrollView {
                VStack(spacing: 24) {

                    // ✏️ Informations utilisateur
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Informations")
                            .font(.headline)

                        TextField("Nom d'utilisateur", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        ZStack(alignment: .leading) {
                            if isEditing && password.isEmpty {
                                Text("Laisser vide pour ne pas changer")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 6)
                            }
                            SecureField("Mot de passe", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }

                    Divider()

                    // ✅ Boutons
                    VStack(spacing: 12) {
                        Button(action: {
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
                                    let now = ISO8601DateFormatter().string(from: Date())
                                    let create = GestionnaireCreate(
                                        username: username,
                                        email: email,
                                        password: password,
                                        createdAt: now,
                                        updatedAt: now
                                    )
                                    await viewModel.createGestionnaire(create)
                                }
                                onDismiss()
                            }
                        }) {
                            Text(isEditing ? "Mettre à jour" : "Créer")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(username.isEmpty || email.isEmpty || (!isEditing && password.isEmpty))

                        Button("Annuler") {
                            onDismiss()
                        }
                        .foregroundColor(.red)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(isEditing ? "Modifier le gestionnaire" : "Ajouter un gestionnaire")
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
