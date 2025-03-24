//
//  StatisticsDashboardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct StatisticsDashboardView: View {
    @StateObject private var viewModel = StatisticViewModel()
    @State private var selectedSessionId: Int? = nil

    let sessions: [Session] // Injecté depuis l'extérieur (sessions chargées par ailleurs)

    var body: some View {
        VStack(alignment: .leading) {
            // 🧩 Sélecteur de session
            Picker("Session", selection: $selectedSessionId) {
                Text("Sélectionner une session").tag(nil as Int?)
                ForEach(sessions, id: \.sessionId) { session in
                    Text(session.name).tag(session.sessionId as Int?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)

            // 📊 Contenu des statistiques
            if let sessionId = selectedSessionId {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if viewModel.isLoading {
                            ProgressView("Chargement des statistiques...")
                                .frame(maxWidth: .infinity)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            if let balance = viewModel.globalBalance {
                                FinancialSummaryView(balance: balance)
                            }

                            SalesCountCardView(count: viewModel.salesCount)

                            SalesOverTimeChartView(data: viewModel.salesOverTime)

                            if !viewModel.topGames.isEmpty {
                                TopGamesTableView(topGames: viewModel.topGames)
                            }

                            if !viewModel.vendorShares.isEmpty {
                                VendorPieChartView(vendorShares: viewModel.vendorShares)
                            }

                            if let stats = viewModel.vendorStats {
                                VendorStatsCardView(stats: stats)
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: selectedSessionId) { newValue in
                    if let id = newValue {
                        Task {
                            await viewModel.fetchAll(for: id)
                        }
                    }
                }
            } else {
                Spacer()
                Text("Veuillez sélectionner une session pour voir les statistiques.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }
        }
        .navigationTitle("Statistiques")
        .onAppear {
            // Si une session est déjà sélectionnée par défaut
            if let defaultSession = sessions.first {
                selectedSessionId = defaultSession.sessionId
                Task {
                    await viewModel.fetchAll(for: defaultSession.sessionId)
                }
            }
        }
    }
}
