import Foundation
import Combine

class StockService {
    static let shared = StockService()
    private let apiService = APIService()
    
    func getAllStocks(sessionId: Int) -> AnyPublisher<[Stock], APIError> {
            let endpoint = "/stocks/\(sessionId)"
            return apiService.getRaw(endpoint)
                .tryMap { data -> [Stock] in
                    // Tentative de décodage en tableau
                    if let stocks = try? JSONDecoder().decode([Stock].self, from: data) {
                        return stocks
                    }
                    // Sinon, tentative de décodage en objet Stock unique, puis le mettre dans un tableau
                    if let stock = try? JSONDecoder().decode(Stock.self, from: data) {
                        return [stock]
                    }
                    throw APIError.decodingError(DecodingError.dataCorrupted(DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Le format du JSON est inconnu."
                    )))
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
