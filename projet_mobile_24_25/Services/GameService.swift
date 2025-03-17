import Foundation
import Combine

// 1) Ton enum pour décrire chaque champ ou fichier
enum FormDataPart {
    case text(name: String, value: String)
    case file(name: String, fileName: String, mimeType: String, data: Data)
}

// 2) Ton struct pour stocker fields + files
struct MultipartFormData {
    var fields: [String: String] = [:]
    var files: [String: (filename: String, data: Data, mimeType: String)] = [:]
}

// 3) Extension pour convertir en [FormDataPart]
extension MultipartFormData {
    func toFormDataParts() -> [FormDataPart] {
        var parts: [FormDataPart] = []

        // Champs texte
        for (k, v) in fields {
            parts.append(.text(name: k, value: v))
        }

        // Fichiers
        for (k, file) in files {
            parts.append(.file(name: k,
                               fileName: file.filename,
                               mimeType: file.mimeType,
                               data: file.data))
        }

        return parts
    }
}

// 4) Ton EmptyResponse pour les retours vides
struct EmptyResponse: Codable {}

/// 5) Ton GameService
class GameService {
    static let shared = GameService()
    private let apiService = APIService()

    // GET
    func getGames() -> AnyPublisher<[Game], APIError> {
        apiService.get("/games")
    }

    func getGameById(_ id: Int) -> AnyPublisher<Game, APIError> {
        apiService.get("/games/\(id)")
    }

    // CREATE => POST /games
    func createGame(formData: MultipartFormData) -> AnyPublisher<Game, APIError> {
        // Conversion en [FormDataPart]
        let parts = formData.toFormDataParts()
        return apiService.postMultipart("/games", formDataParts: parts)
    }

    // UPDATE => PUT /games/:id
    func updateGame(_ id: Int, formData: MultipartFormData) -> AnyPublisher<Game, APIError> {
        let parts = formData.toFormDataParts()
        return apiService.putMultipart("/games/\(id)", formDataParts: parts)
    }

    // DELETE => /games/:id
    func deleteGame(_ id: Int) -> AnyPublisher<Void, APIError> {
        apiService.delete("/games/\(id)")
    }

    // GET => /games/:id/stocks
    func getGameStocks(_ gameId: Int) -> AnyPublisher<[Stock], APIError> {
        apiService.get("/games/\(gameId)/stocks")
    }

    // Import CSV => /csvImport/import
    func importGames(_ formData: MultipartFormData) -> AnyPublisher<Void, APIError> {
        let parts = formData.toFormDataParts()
        return apiService.postMultipart("/csvImport/import", formDataParts: parts)
            .map { (_: EmptyResponse) in () }
            .eraseToAnyPublisher()
    }
}
