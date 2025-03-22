import Foundation

class StockService {
    static let shared = StockService()
    private let apiService = APIService()
    
    // Récupérer tous les stocks pour une session donnée
    func getAllStocks() async throws -> [Stock] {
        let endpoint = "/stocks/"
        let data = try await apiService.getRaw(endpoint)

        let decoder = JSONDecoder.customISO8601Decoder 

        // Tentative de décodage en tableau de stocks
        if let stocks = try? decoder.decode([Stock].self, from: data) {
            return stocks
        }

        // Si ce n'est pas un tableau, tentative de décodage en objet unique
        if let stock = try? decoder.decode(Stock.self, from: data) {
            return [stock]
        }

        throw APIError.decodingError(DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: [],
            debugDescription: "Le format du JSON est inconnu."
        )))
    }
}
