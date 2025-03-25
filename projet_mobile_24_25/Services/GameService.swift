//
//  GameService.swift
//  projet_mobile_24_25
//
//  Created par Samy Louchahi le 17/03/2025.
//

import Foundation

/// 1) Enum pour définir un champ ou un fichier
enum FormDataPart {
    case text(name: String, value: String)
    case file(name: String, fileName: String, mimeType: String, data: Data)
}

/// 2) Struct pour stocker les champs texte et fichiers
struct MultipartFormData {
    var fields: [String: String] = [:]
    var files: [String: (filename: String, data: Data, mimeType: String)] = [:]
}

/// 3) Extension pour convertir en [FormDataPart]
extension MultipartFormData {
    func toFormDataParts() -> [FormDataPart] {
        var parts: [FormDataPart] = []

        for (k, v) in fields {
            parts.append(.text(name: k, value: v))
        }

        for (k, file) in files {
            parts.append(.file(name: k,
                               fileName: file.filename,
                               mimeType: file.mimeType,
                               data: file.data))
        }

        return parts
    }
}

/// 4) Struct pour les réponses vides
struct EmptyResponse: Codable {}

/// 5) Service pour gérer les opérations liées aux jeux
class GameService {
    static let shared = GameService()
    private let apiService = APIService()

    // MARK: - GET
    /// Récupérer tous les jeux
    func getGames() async throws -> [Game] {
        return try await apiService.get("/games")
    }

    /// Récupérer un jeu par ID
    func getGameById(_ id: Int) async throws -> Game {
        return try await apiService.get("/games/\(id)")
    }

    // MARK: - CREATE
    /// Créer un jeu
    func createGame(formData: MultipartFormData) async throws -> Game {
        let parts = formData.toFormDataParts()
        return try await apiService.postMultipart("/games", formDataParts: parts)
    }

    // MARK: - UPDATE
    /// Mettre à jour un jeu
    func updateGame(_ id: Int, formData: MultipartFormData) async throws -> Game {
        let parts = formData.toFormDataParts()
        return try await apiService.putMultipart("/games/\(id)", formDataParts: parts)
    }

    // MARK: - DELETE
    /// Supprimer un jeu
    func deleteGame(_ id: Int) async throws {
        try await apiService.delete("/games/\(id)")
    }

    // MARK: - STOCKS
    /// Récupérer les stocks d'un jeu
    func getGameStocks(_ gameId: Int) async throws -> [Stock] {
        return try await apiService.get("/games/\(gameId)/stocks")
    }

    // MARK: - IMPORT CSV
    /// Importer un CSV contenant des jeux
    func importGames(_ formData: MultipartFormData) async throws {
        let parts = formData.toFormDataParts()
        _ = try await apiService.postMultipart("/csvImport/import", formDataParts: parts) as EmptyResponse
    }
}
