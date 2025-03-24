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
        if sessionVM.sessions.isEmpty {
            ProgressView("Chargement des sessions…")
        } else {
            StatisticsDashboardView(sessions: sessionVM.sessions)
        }
    }
}
