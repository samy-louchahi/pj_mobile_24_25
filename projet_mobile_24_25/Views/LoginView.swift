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
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 8) {
                Image(systemName: "dice.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)

                Text("Connexion à l’espace gestion")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }

            if let error = authviewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal)
            }

            Picker("Rôle", selection: $authviewModel.role) {
                Text("Admin").tag(UserRole.admin)
                Text("Gestionnaire").tag(UserRole.gestionnaire)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            VStack(spacing: 16) {
                if authviewModel.role == .admin {
                    TextField("Email", text: $authviewModel.email)
                        .textFieldStyle(LoginFieldStyle())
                } else {
                    TextField("Nom d'utilisateur", text: $authviewModel.username)
                        .textFieldStyle(LoginFieldStyle())
                }

                SecureField("Mot de passe", text: $authviewModel.password)
                    .textFieldStyle(LoginFieldStyle())
            }
            .padding(.horizontal)

            Button {
                Task { await authviewModel.login() }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right")
                    Text("Se connecter")
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .foregroundColor(.blue)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            Spacer()
        }
        .padding()
        .ignoresSafeArea()
    }
}

struct LoginFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
    }
}
