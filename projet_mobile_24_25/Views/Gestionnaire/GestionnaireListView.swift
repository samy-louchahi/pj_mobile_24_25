//
//  GestionnaireListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 22/03/2025.
//


import SwiftUI

struct GestionnaireListView: View {
    @StateObject private var viewModel = GestionnaireViewModel()
    @State private var showForm = false
    @State private var isEditing = false
    @State private var selectedGestionnaire: Gestionnaire?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Gestion des gestionnaires")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: {
                        selectedGestionnaire = nil
                        isEditing = false
                        showForm = true
                    }) {
                        Label("Ajouter", systemImage: "plus")
                    }
                }
                .padding()

                List {
                    ForEach(viewModel.gestionnaires) { gestionnaire in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(gestionnaire.username)
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    selectedGestionnaire = gestionnaire
                                    isEditing = true
                                    showForm = true
                                }) {
                                    Image(systemName: "pencil")
                                }
                                .padding(.trailing, 8)

                                Button() {
                                    Task{await viewModel.deleteGestionnaire(id: gestionnaire.id)}
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }

                            Text(gestionnaire.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Créé le \(formattedDate(gestionnaire.createdAt))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .onAppear {
                Task{ await viewModel.fetchGestionnaires() }
            }
            .sheet(isPresented: $showForm) {
                GestionnaireFormView(
                    viewModel: viewModel,
                    isEditing: isEditing,
                    existingGestionnaire: selectedGestionnaire,
                    onDismiss: { showForm = false }
                )
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
