//
//  DepositViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI
import Combine

class DepositViewModel: ObservableObject {
    // Liste complète des dépôts
    @Published var deposits: [Deposit] = []
    @Published var loading: Bool = false
    @Published var errorMessage: String?
    @Published var sessions: [Session] = []
    @Published var sellers: [Seller] = []
    @Published var games: [Game] = []

    private let depositService = DepositService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
            fetchData()
        }
    func fetchData() {
            let sessionPublisher = SessionService.shared.getSessions().catch { _ in Just<[Session]>([]) }
            let sellerPublisher = SellerService.shared.getSellers().catch { _ in Just<[Seller]>([]) }
            let gamePublisher = GameService.shared.getGames().catch { _ in Just<[Game]>([]) }
            let depositPublisher = DepositService.shared.getAllDeposits().catch { _ in Just<[Deposit]>([]) }

            Publishers.Zip4(sessionPublisher, sellerPublisher, gamePublisher, depositPublisher)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] sessions, sellers, games, deposits in
                    self?.sessions = sessions
                    self?.sellers = sellers
                    self?.games = games
                    self?.deposits = deposits
                }
                .store(in: &cancellables)
        }

    // MARK: - Fetch Deposits
    func fetchDeposits() {
        loading = true
        depositService.getAllDeposits()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Erreur lors de la récupération des dépôts : \(error)"
                }
            } receiveValue: { deposits in
                self.deposits = deposits
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Create Deposit
    func createDeposit(_ depositData: DepositCreate) {
        loading = true
        depositService.createDeposit(depositData)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    self.fetchDeposits()
                case .failure(let error):
                    self.errorMessage = "Erreur création dépôt : \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: - Update Deposit (optionnel)
    func updateDeposit(id: Int, depositData: PartialDeposit) {
        loading = true
        depositService.updateDeposit(id, depositData)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    self.fetchDeposits()
                case .failure(let error):
                    self.errorMessage = "Erreur mise à jour dépôt : \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: - Delete Deposit
    func deleteDeposit(id: Int) {
        loading = true
        depositService.deleteDeposit(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    // Met à jour la liste locale en supprimant le dépôt
                    self.deposits.removeAll { $0.depositId == id }
                case .failure(let error):
                    self.errorMessage = "Erreur suppression dépôt : \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
