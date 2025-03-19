//
//  LoginView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Connexion")
                    .font(.title)
                    .padding()

                // Affichage de l'erreur
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                Picker("Rôle", selection: $viewModel.role) {
                    Text("Admin").tag(UserRole.admin)
                    Text("Gestionnaire").tag(UserRole.gestionnaire)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Champs de texte
                if viewModel.role == .admin {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } else {
                    TextField("Nom d'utilisateur", text: $viewModel.username)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                SecureField("Mot de passe", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Button(action: {
                    Task {await viewModel.login()}
                }) {
                    if viewModel.isLoading {
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

                // Navigation selon isLoggedIn
                if viewModel.isLoggedIn {
                    // Méthode 1 : on affiche un NavigationLink invisible pour "pousser" vers l'écran principal
                    NavigationLink(
                        destination: MainTabView(),
                        isActive: $viewModel.isLoggedIn
                    ) {
                        EmptyView()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview{
    LoginView()
}
