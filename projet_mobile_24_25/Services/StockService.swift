import Foundation

class StockService {
    static let shared = StockService()
    private let apiService = APIService()
    
    // Récupérer tous les stocks pour une session donnée
    func getAllStocks(sessionId: Int) async throws -> [Stock] {
        let endpoint = "/stocks/\(sessionId)"
        let data = try await apiService.getRaw(endpoint)
        
        // Tentative de décodage en tableau de stocks
        if let stocks = try? JSONDecoder().decode([Stock].self, from: data) {
            return stocks
        }
        // Si ce n'est pas un tableau, tentative de décodage en objet unique puis conversion en tableau
        if let stock = try? JSONDecoder().decode(Stock.self, from: data) {
            return [stock]
        }
        throw APIError.decodingError(DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: [],
            debugDescription: "Le format du JSON est inconnu."
        )))
    }
}
