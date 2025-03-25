//
//  PasswordChangeView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 25/03/2025.
//

import SwiftUI

struct PasswordChangeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var auth: AuthViewModel
    @StateObject var viewModel = GestionnaireViewModel()

    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String? = nil
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nouveau mot de passe")) {
                    SecureField("Nouveau mot de passe", text: $newPassword)
                    SecureField("Confirmer le mot de passe", text: $confirmPassword)
                }

                if let error = errorMessage {
                    Text(error).foregroundColor(.red)
                }

                Button("Enregistrer") {
                    Task { await updatePassword() }
                }
                .disabled(isSaving)
            }
            .navigationTitle("Changer le mot de passe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func updatePassword() async {
        guard let userId = auth.gestionnaireId else {
            errorMessage = "Utilisateur non identifié."
            return
        }

        guard !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "Les mots de passe ne correspondent pas."
            return
        }

        isSaving = true
        errorMessage = nil

        let partial = PartialGestionnaire(
            username: nil,
            email: nil,
            password: newPassword,
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )

        await viewModel.updateGestionnaire(id: userId, data: partial)

        if let error = viewModel.errorMessage {
            errorMessage = error
        } else {
            dismiss()
        }

        isSaving = false
    }
}
