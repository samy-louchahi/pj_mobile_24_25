//
//  APIError.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation
import Combine

/// Représente les erreurs réseau possibles
enum APIError: Error {
    case invalidURL
    case unauthorized
    case forbidden
    case decodingError(Error)
    case networkError(Error)
    case unexpectedStatusCode(Int)
    case unknown
}

/// Service pour gérer les appels REST à l'API
class APIService {
    /// Base URL de ton backend
    private let baseURL = "https://api-awi-depot-jeu.onrender.com/api"
    
    /// Récupération du token depuis le Keychain ou UserDefaults
    private func getToken() -> String? {
        // À adapter selon ta logique (UserDefaults ou Keychain)
        return UserDefaults.standard.string(forKey: "token")
    }

    /// Exemple de méthode GET générique
    func get<T: Decodable>(_ endpoint: String) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Ajouter le header JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Ajouter le token si présent
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                // Vérifier le code HTTP pour gérer 401,403
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200...299:
                            return data
                        case 401:
                            throw APIError.unauthorized
                        case 403:
                            throw APIError.forbidden
                        default:
                            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
                    }
                }
                return data
            }
            .mapError { error -> APIError in
                // Transformer l'erreur Combine en erreur APIError
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .networkError(error)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder()) // Décodage JSON -> T
            .mapError { error -> APIError in
                if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                } else {
                    return (error as? APIError) ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    /// Exemple de méthode POST générique (pour créer ou mettre à jour une ressource)
    func post<T: Decodable, U: Encodable>(_ endpoint: String, body: U) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Ajouter le header JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Ajouter le token si présent
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            // Encoder le body en JSON
            let encodedBody = try JSONEncoder().encode(body)
            request.httpBody = encodedBody
        } catch {
            return Fail(error: APIError.networkError(error)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200...299:
                            return data
                        case 401:
                            throw APIError.unauthorized
                        case 403:
                            throw APIError.forbidden
                        default:
                            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
                    }
                }
                return data
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .networkError(error)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                } else {
                    return (error as? APIError) ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }
    func put<T: Decodable, U: Encodable>(_ endpoint: String, body: U) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        do {
            let encodedBody = try JSONEncoder().encode(body)
            request.httpBody = encodedBody
        } catch {
            return Fail(error: APIError.networkError(error)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200...299:
                            return data
                        case 401:
                            throw APIError.unauthorized
                        case 403:
                            throw APIError.forbidden
                        default:
                            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
                    }
                }
                return data
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .networkError(error)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                } else {
                    return (error as? APIError) ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }
    func delete(_ endpoint: String) -> AnyPublisher<Void, APIError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200...299:
                            return ()
                        case 401:
                            throw APIError.unauthorized
                        case 403:
                            throw APIError.forbidden
                        default:
                            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
                    }
                }
                return ()
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // Etc. (PUT, DELETE, upload CSV, etc.)
    
    // Exemple pour GESTION CSV (multipart/form-data)
    // Tu peux créer une méthode spécialisée ou un service différent
    func uploadCSV(endpoint: String, csvData: Data, fileName: String) -> AnyPublisher<Void, APIError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Créer la boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Construire le corps multipart
        var body = Data()
        // -- boundary
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        // Content-Disposition: form-data; name="file"; filename="xxxx.csv"
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        // Content-Type: text/csv
        body.append("Content-Type: text/csv\r\n\r\n".data(using: .utf8)!)
        // données
        body.append(csvData)
        // nouvelle ligne
        body.append("\r\n".data(using: .utf8)!)
        // close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200...299:
                            // OK, on renvoie juste Void
                            return ()
                        case 401:
                            throw APIError.unauthorized
                        case 403:
                            throw APIError.forbidden
                        default:
                            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
                    }
                }
                return ()
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
