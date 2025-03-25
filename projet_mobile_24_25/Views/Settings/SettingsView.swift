//
//  SettingsView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 22/03/2025.
//


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var showPasswordForm = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Compte")) {
                    Button("Modifier mon mot de passe") {
                        showPasswordForm = true
                    }

                    Button("Déconnexion", role: .destructive) {
                        Task {
                            await auth.logout()
                        }
                    }
                }
            }
            .navigationTitle("Paramètres")
            .sheet(isPresented: $showPasswordForm) {
                PasswordChangeView()
            }
        }
    }
}
