//
//  SessionListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = SessionViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView("Chargement des sessions...")
                }
                else if let err = viewModel.errorMessage {
                    Text(err).foregroundColor(.red)
                }
                else if viewModel.sessions.isEmpty {
                    // Aucune session
                    VStack(spacing: 12) {
                        Text("Aucune session active")
                            .font(.title2)
                        Text("Commencez une nouvelle session de dépôt-vente pour gérer les jeux, vendeurs, etc.")
                            .foregroundColor(.gray)
                        Button("+ Créer une nouvelle session") {
                            viewModel.openAddForm()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                else {
                    // Affichage de la liste
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.sessions) { session in
                                SessionCardView(
                                    session: session,
                                    onDelete: { sid in viewModel.openDeleteConfirm(sid) },
                                    onUpdate: { s in viewModel.openUpdateForm(s) },
                                    onViewDetails: { s in viewModel.openDetail(s.id) }
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Gestion des Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+ Créer") {
                        viewModel.openAddForm()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddForm) {
                SessionAddView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showUpdateForm) {
                if let editing = viewModel.editingSession {
                    SessionUpdateView(viewModel: viewModel, session: editing)
                }
            }
            // Détail
            .sheet(isPresented: $viewModel.showDetail) {
                if let sid = viewModel.detailSessionId {
                    SessionDetailView(viewModel: viewModel, sessionId: sid)
                }
            }
            // Confirmation suppression
            .alert("Confirmer la suppression?", isPresented: $viewModel.showDeleteConfirm, actions: {
                Button("Annuler", role: .cancel) {
                    viewModel.closeDeleteConfirm()
                }
                Button("Supprimer", role: .destructive) {
                    if let sid = viewModel.sessionToDelete {
                        Task{await viewModel.deleteSession(sid)}
                    }
                }
            }, message: {
                Text("Êtes-vous sûr de vouloir supprimer cette session ?")
            })
        }
        .onAppear {
            Task {await viewModel.fetchSessions()}
        }
    }
}
#Preview {
    SessionListView()
}
