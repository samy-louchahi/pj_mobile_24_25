//
//  UserRole.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI
import Combine

enum UserRole: String {
    case admin
    case gestionnaire
}

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

    // MARK: - Publishers
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Services
    private let apiService = APIService()

    init() {}

    // MARK: - Methods

    func login() {
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
            body = [
                "email": email,
                "password": password
            ]
        } else {
            body = [
                "username": username,
                "password": password
            ]
        }

        // Appel API via la méthode post
        apiService.post(endpoint, body: body)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Erreur lors du login:", error)
                    self.errorMessage = "Erreur lors de la connexion."
                    // Si besoin, on peut gérer spécifiquement APIError.unauthorized, etc.
                }
            } receiveValue: { (response: LoginResponse) in
                // Récupérer le token
                let token = response.token
                // Stocker le token localement (UserDefaults ou Keychain)
                UserDefaults.standard.set(token, forKey: "token")
                
                // Mettre à jour l'état
                self.isLoggedIn = true
            }
            .store(in: &self.cancellables)
    }
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        isLoggedIn = false
        email = ""
        username = ""
        password = ""
        errorMessage = nil
        isLoading = false
    }
}

/// La réponse JSON attendue après le login (token)
struct LoginResponse: Codable {
    let token: String
}
