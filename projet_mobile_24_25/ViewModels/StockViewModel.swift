import SwiftUI
import Combine

class StockViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var stocksDict: [Int: Stock] = [:]  // Dictionnaire indexé par stockId
    @Published var selectedSession: Int? = nil
    @Published var loading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let sessionService = SessionService.shared
    private let stockService = StockService.shared

    init() {
        fetchSessions()
    }
    
    func fetchSessions() {
        sessionService.getSessions()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "Erreur lors de la récupération des sessions: \(error)"
                }
            } receiveValue: { sessions in
                self.sessions = sessions
                // Sélection automatique de la première session active, par exemple
                if let active = sessions.first(where: { $0.status }) {
                    self.selectedSession = active.sessionId
                    self.fetchStocks()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchStocks() {
        guard let sessionId = selectedSession else {
            self.stocksDict = [:]
            return
        }
        loading = true
        stockService.getAllStocks(sessionId: sessionId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                if case let .failure(error) = completion {
                    self.errorMessage = "Erreur lors de la récupération des stocks: \(error)"
                }
            } receiveValue: { stocks in
                self.stocksDict = Dictionary(uniqueKeysWithValues: stocks.map { ($0.stockId, $0) })
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedSession(_ sessionId: Int?) {
        self.selectedSession = sessionId
        fetchStocks()
    }
}
