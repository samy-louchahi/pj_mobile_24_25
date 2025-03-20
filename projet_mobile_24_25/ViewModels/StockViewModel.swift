//
//  SaleViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 18/03/2025.
//

import SwiftUI

@MainActor
class StockViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var stocksDict: [Int: Stock] = [:]  // Dictionnaire indexé par stockId
    @Published var selectedSession: Int? = nil
    @Published var loading: Bool = false
    @Published var errorMessage: String?

    private let sessionService = SessionService.shared
    private let stockService = StockService.shared

    init() {
        Task { await fetchSessions() }
    }
    
    func fetchSessions() async {
        do {
            sessions = try await sessionService.getSessions()
            if let active = sessions.first(where: { $0.status }) {
                selectedSession = active.sessionId
                await fetchStocks()
            }
        } catch {
            errorMessage = "Erreur lors de la récupération des sessions: \(error.localizedDescription)"
        }
    }
    
    func fetchStocks() async {
        do {
            loading = true
            let stocks = try await stockService.getAllStocks()
            stocksDict = Dictionary(uniqueKeysWithValues: stocks.map { ($0.stockId, $0) })
        } catch {
            print("pb stock \(error) ")
            errorMessage = "Erreur lors de la récupération des stocks: \(error.localizedDescription)"
        }
        loading = false
    }
    
    func updateSelectedSession(_ sessionId: Int?) {
        selectedSession = sessionId
        Task { await fetchStocks() }
    }
}
