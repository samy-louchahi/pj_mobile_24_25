//
//  StatisticsTabView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct StatisticsTabView: View {
    @StateObject private var sessionVM = SessionViewModel()

    var body: some View {
        Group {
            if sessionVM.sessions.isEmpty && sessionVM.loading {
                ProgressView("Chargement des sessions…")
            } else {
                StatisticsDashboardView(sessions: sessionVM.sessions)
            }
        }
        .onAppear {
            if sessionVM.sessions.isEmpty {
                Task {
                    await sessionVM.fetchSessions()
                }
            }
        }
    }
}
