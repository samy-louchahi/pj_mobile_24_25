//
//  LoginView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authviewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Gestion des dépôts et ventes de jeux")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 32)

            Image(systemName: "gamecontroller.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .padding(.vertical, 8)

            Text("Connexion")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 16)

            if let error = authviewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Picker("Rôle", selection: $authviewModel.role) {
                Text("Admin").tag(UserRole.admin)
                Text("Gestionnaire").tag(UserRole.gestionnaire)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if authviewModel.role == .admin {
                TextField("Email", text: $authviewModel.email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            } else {
                TextField("Nom d'utilisateur", text: $authviewModel.username)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            SecureField("Mot de passe", text: $authviewModel.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button(action: {
                Task { await authviewModel.login() }
            }) {
                if authviewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Se connecter")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.vertical)

            Spacer()
        }
        .padding()
    }
}
