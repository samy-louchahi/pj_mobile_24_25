//
//  SessionViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//

import SwiftUI

@MainActor
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
    @Published var balance: GlobalBalance?

    // MARK: - Confirmation de suppression
    @Published var sessionToDelete: Int?
    @Published var showDeleteConfirm: Bool = false

    private let sessionService = SessionService.shared

    // MARK: - Init
    init() {
        Task { await fetchSessions() }
    }

    // MARK: - Fetch Sessions
    func fetchSessions() async {
        do {
            loading = true
            sessions = try await sessionService.getSessions()
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Créer une session
    func createSession(_ newSession: SessionCreate) async {
        do {
            loading = true
            _ = try await sessionService.createSession(newSession)
            showAddForm = false
            await fetchSessions()
        } catch {
            errorMessage = "Erreur création session : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Mettre à jour une session
    func updateSession(sessionId: Int, _ updated: SessionUpdate) async {
        do {
            loading = true
            _ = try await sessionService.updateSession(sessionId, updated)
            showUpdateForm = false
            editingSession = nil
            await fetchSessions()
        } catch {
            errorMessage = "Erreur mise à jour session : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Supprimer une session
    func deleteSession(_ sessionId: Int) async {
        do {
            loading = true
            try await sessionService.deleteSession(sessionId)
            sessions.removeAll { $0.id == sessionId }
            showDeleteConfirm = false
            sessionToDelete = nil
        } catch {
            errorMessage = "Erreur suppression session : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Récupérer le solde global
    func getGlobalBalance(_ sessionId: Int) async {
        do {
            loading = true
            balance = try await sessionService.getGlobalBalance(sessionId)
        } catch {
            errorMessage = "Erreur de calcul du solde global : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Gestion des modales
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

    // MARK: - Gestion des détails
    func openDetail(_ sessionId: Int) {
        detailSessionId = sessionId
        showDetail = true
    }

    func closeDetail() {
        detailSessionId = nil
        showDetail = false
    }
}
