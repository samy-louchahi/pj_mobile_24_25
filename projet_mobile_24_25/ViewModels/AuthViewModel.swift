//
//  AuthViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//

import SwiftUI

enum UserRole: String {
    case admin
    case gestionnaire
}

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Input Properties
    @Published var role: UserRole = .admin
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""

    // MARK: - Output / State
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    // MARK: - Services
    private let apiService = APIService()

    init() {
        Task {await checkIfLoggedIn()}
    }

    // MARK: - Methods

    /// Fonction pour gérer la connexion utilisateur
    func login() async {
        // Réinitialiser l’erreur
        errorMessage = nil

        // Vérifier que les champs obligatoires sont remplis
        switch role {
        case .admin:
            guard !email.isEmpty, !password.isEmpty else {
                self.errorMessage = "Veuillez remplir tous les champs."
                return
            }
        case .gestionnaire:
            guard !username.isEmpty, !password.isEmpty else {
                self.errorMessage = "Veuillez remplir tous les champs."
                return
            }
        }

        isLoading = true

        // Construire le endpoint en fonction du rôle
        let endpoint = (role == .admin) ? "/auth/admin/login" : "/auth/gestionnaire/login"

        // Construire le payload JSON
        var body: [String: String] = [:]
        if role == .admin {
            body = ["email": email, "password": password]
        } else {
            body = ["username": username, "password": password]
        }

        // Effectuer la requête
        do {
            let response: LoginResponse = try await apiService.post(endpoint, body: body)
            // Stocker le token localement (UserDefaults ou Keychain)
            UserDefaults.standard.set(response.token, forKey: "token")
            
            // Mettre à jour l'état de connexion
            isLoggedIn = true
        } catch {
            print("Erreur lors du login:", error)
            self.errorMessage = "Erreur lors de la connexion."
        }

        isLoading = false
    }

    /// Fonction pour gérer la déconnexion
    func logout() async {
            UserDefaults.standard.removeObject(forKey: "token")
            isLoggedIn = false
        }

    /// Vérifie si un token est présent pour maintenir la connexion
    func checkIfLoggedIn() async {
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                isLoggedIn = false
                return
            }

            // 1️⃣ Vérifier si le token est un JWT valide et non expiré
            if !isTokenValid(token) {
                await logout()
                return
            }

            // 2️⃣ Vérifier avec le backend si le token est encore valide
            await validateToken(token)
        }
    private func isTokenValid(_ token: String) -> Bool {
            let parts = token.split(separator: ".")
            guard parts.count == 3 else { return false }

            let payloadData = parts[1] // Le payload du JWT (Base64)
            guard let decodedData = Data(base64Encoded: String(payloadData) + "==") else { return false }

            do {
                if let json = try JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any],
                   let exp = json["exp"] as? TimeInterval {
                    let expirationDate = Date(timeIntervalSince1970: exp)
                    return expirationDate > Date()
                }
            } catch {
                return false
            }

            return false
        }
    private func validateToken(_ token: String) async {
            do {
                let response: TokenValidationResponse = try await apiService.get("/auth/validate-token")
                
                if response.isValid {
                    isLoggedIn = true
                } else {
                    await logout()
                }
            } catch {
                await logout()
            }
        }


    
}
struct TokenValidationResponse: Codable {
    let isValid: Bool
}

/// La réponse JSON attendue après le login (token)
struct LoginResponse: Codable {
    let token: String
}
