//
//  SessionViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI
import Combine

/// ViewModel pour la gestion des Sessions
class SessionViewModel: ObservableObject {
    // MARK: - État principal
    @Published var sessions: [Session] = []
    @Published var loading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Formulaires / Modales
    @Published var showAddForm: Bool = false
    @Published var showUpdateForm: Bool = false
    @Published var editingSession: Session?

    // MARK: - Détail
    @Published var showDetail: Bool = false
    @Published var detailSessionId: Int?
    @Published var balance : GlobalBalance?

    // MARK: - Confirmation de suppression
    @Published var sessionToDelete: Int?
    @Published var showDeleteConfirm: Bool = false

    // MARK: - Autres états éventuels

    private let sessionService = SessionService.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Méthodes principales

    func fetchSessions() {
        loading = true
        sessionService.getSessions()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessage = "Erreur: \(error)"
                }
            } receiveValue: { sessions in
                self.sessions = sessions
            }
            .store(in: &cancellables)
    }

    /// Créer une nouvelle session (pour l’AddSessionModal)
    func createSession(_ newSession: SessionCreate) {
        // newSession = { name, start_date, end_date, fees, commission, ... }
        loading = true
        sessionService.createSession(newSession)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    // On recharge la liste
                    self.fetchSessions()
                    // On ferme la modale
                    self.showAddForm = false
                case .failure(let error):
                    self.errorMessage = "Erreur création session: \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    /// Mettre à jour une session (pour l’UpdateSessionModal)
    func updateSession(sessionId: Int, _ updated: SessionUpdate) {
        // updated = { name, start_date, end_date, fees, commission, status }
        loading = true
        sessionService.updateSession(sessionId, updated)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    self.fetchSessions()
                    self.showUpdateForm = false
                    self.editingSession = nil
                case .failure(let error):
                    self.errorMessage = "Erreur update session: \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    /// Supprime une session
    func deleteSession(_ sessionId: Int) {
        loading = true
        sessionService.deleteSession(sessionId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    // Mettre à jour localement
                    self.sessions.removeAll(where: { $0.id == sessionId })
                    // Fermer la confirmation
                    self.showDeleteConfirm = false
                    self.sessionToDelete = nil
                case .failure(let error):
                    self.errorMessage = "Erreur suppression session: \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    func getGlobalBalance(_ sessionId: Int){
        loading = true
        sessionService.getGlobalBalance(sessionId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Erreur de calcul du solde global: \(error)"
                }
            } receiveValue: { balance in
                self.balance = balance
            }
            .store(in: &cancellables)  
    }

    // MARK: - Ouverture / Fermeture des modales

    func openAddForm() {
        editingSession = nil
        showAddForm = true
    }

    func closeAddForm() {
        showAddForm = false
    }

    func openUpdateForm(_ session: Session) {
        editingSession = session
        showUpdateForm = true
    }

    func closeUpdateForm() {
        showUpdateForm = false
        editingSession = nil
    }

    func openDeleteConfirm(_ sessionId: Int) {
        sessionToDelete = sessionId
        showDeleteConfirm = true
    }

    func closeDeleteConfirm() {
        sessionToDelete = nil
        showDeleteConfirm = false
    }

    // MARK: - Détail / Balance
    /// Ex: pour ouvrir un "SessionDetailModal"
    func openDetail(_ sessionId: Int) {
        detailSessionId = sessionId
        showDetail = true
    }

    func closeDetail() {
        detailSessionId = nil
        showDetail = false
    }

}
