//
//  APIService.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//

import Foundation

/// Représente les erreurs réseau possibles
enum APIError: Error {
    case invalidURL
    case unauthorized
    case forbidden
    case decodingError(Error)
    case networkError(Error)
    case unexpectedStatusCode(Int)
    case unknown
    case invalidResponse
}

/// Service pour gérer les appels REST à l'API
class APIService {
    /// Base URL de ton backend
    private let baseURL = "https://api-awi-depot-jeu-backup.onrender.com/api"
    
    /// Récupération du token depuis le Keychain ou UserDefaults
    private func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }

    // MARK: - GET (Async)
    func get<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {

        }


        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {

                throw APIError.invalidResponse
            }


            if !(200...299).contains(httpResponse.statusCode) {

                throw APIError.unexpectedStatusCode(httpResponse.statusCode)
            }

            try validateResponse(response)


            do {
                let decoded = try decodeJSON(data) as T
                return decoded
            } catch {
                throw error
            }

        } catch {
            print("🔥 Erreur lors de la requête : \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - POST (Async)
    func post<T: Decodable, U: Encodable>(_ endpoint: String, body: U) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            print("invalid url")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try encodeJSON(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        return try decodeJSON(data)
    }

    // MARK: - PUT (Async)
    func put<T: Decodable, U: Encodable>(_ endpoint: String, body: U) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            print("invalid url")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try encodeJSON(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        return try decodeJSON(data)
    }

    // MARK: - DELETE (Async)
    func delete(_ endpoint: String) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            print("invalid url")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }

    // MARK: - Upload CSV (Multipart)
    func uploadCSV(endpoint: String, csvData: Data, fileName: String) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            print("invalid url")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: text/csv\r\n\r\n".data(using: .utf8)!)
        body.append(csvData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }
    
    func postMultipart<T: Decodable>(
        _ endpoint: String,
        formDataParts: [FormDataPart]
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            print("invalid url")
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Boundary pour le multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Token d'authentification
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Construire le body
        var body = Data()

        for part in formDataParts {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)

            switch part {
            case .text(let name, let value):
                let disposition = "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
                body.append(disposition.data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)

            case .file(let name, let fileName, let mimeType, let data):
                let disposition = "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
                body.append(disposition.data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        // Fin du body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Effectuer la requête asynchrone
        let (data, response) = try await URLSession.shared.data(for: request)

        // Vérification du code HTTP
        guard let httpResponse = response as? HTTPURLResponse else {
            print("unknown response")
            throw APIError.unknown
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            print("unauthorized")
            throw APIError.unauthorized
        case 403:
            print("forbidden")
            throw APIError.forbidden
        default:
            print("unexepté code HTTP \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }

        // **Cas où la réponse est vide**
        if T.self == EmptyResponse.self {
            return EmptyResponse() as! T // Trick pour forcer Swift à accepter
        }

        // **Cas où la réponse est un objet JSON**
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("error decoding JSON: \(error)\n")
            throw APIError.decodingError(error)
        }
    }
    
    func putMultipart<T: Decodable>(
        _ endpoint: String,
        formDataParts: [FormDataPart]
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            print("invalid url")
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        // Boundary pour le multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Token d'authentification
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Construire le body
        var body = Data()

        for part in formDataParts {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)

            switch part {
            case .text(let name, let value):
                let disposition = "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
                body.append(disposition.data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)

            case .file(let name, let fileName, let mimeType, let data):
                let disposition = "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
                body.append(disposition.data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        // Fin du body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Effectuer la requête asynchrone
        let (data, response) = try await URLSession.shared.data(for: request)

        // Vérification du code HTTP
        guard let httpResponse = response as? HTTPURLResponse else {
            print("unknow")
            throw APIError.unknown
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            print("unauthorized")
            throw APIError.unauthorized
        case 403:
            print("forbidden")
            throw APIError.forbidden
        default:
            print("unexepté code HTTP \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }

        // Décoder la réponse en objet de type T
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingError(error)
        }
    }
    func getRaw(_ endpoint: String) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint) else {
            print("invalid url")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                print("unauthorized")
                throw APIError.unauthorized
            case 403:
                print("forbidden")
                throw APIError.forbidden
            default:
                print("unexepté code HTTP \(httpResponse.statusCode)")
                throw APIError.unexpectedStatusCode(httpResponse.statusCode)
            }
        }

        return data
    }

    // MARK: - Helper Methods
    private func encodeJSON<T: Encodable>(_ object: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(object)
    }

    private func decodeJSON<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder.customISO8601Decoder
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Erreur lors du décodage JSON: \(error)")
            throw APIError.decodingError(error)
        }
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            print("unknown response")
            throw APIError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            print("unauthorized")
            throw APIError.unauthorized
        case 403:
            print("forbidden")
            throw APIError.forbidden
        default:
            print("unexepté code HTTP \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
}
