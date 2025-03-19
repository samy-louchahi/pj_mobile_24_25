//
//  StockPageView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

import SwiftUI

struct StockView: View {
    @StateObject private var viewModel = StockViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Gestion des Stocks")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                if !viewModel.sessions.isEmpty {
                    Picker("Choisir une session", selection: Binding(
                        get: { viewModel.selectedSession },
                        set: { newValue in viewModel.updateSelectedSession(newValue) }
                    )) {
                        Text("-- Sélectionnez une session --").tag(Optional<Int>(nil))
                        ForEach(viewModel.sessions, id: \.id) { session in
                            Text("\(session.name) (du \(formattedDate(session.startDate)) au \(formattedDate(session.endDate)))")
                                .tag(Optional(session.sessionId))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                
                if viewModel.selectedSession == nil {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Veuillez sélectionner une session pour afficher les stocks.")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    if viewModel.loading {
                        Spacer()
                        ProgressView("Chargement des stocks...")
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        Text(error)
                            .foregroundColor(.red)
                        Spacer()
                    } else {
                        ScrollView {
                            StockSummaryCardsView(stocksDict: viewModel.stocksDict)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            StockTableView(stocksDict: viewModel.stocksDict)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Stocks")
        }
        .onAppear { viewModel.fetchSessions() }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
