//
//  GameAndStockTabView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 25/03/2025.
//


import SwiftUI

struct GameAndStockTabView: View {
    enum SelectedTab: String, CaseIterable {
        case jeux = "Jeux"
        case stocks = "Stocks"
    }

    @State private var selectedTab: SelectedTab = .jeux

    var body: some View {
        NavigationView {
            VStack {
                Picker("Section", selection: $selectedTab) {
                    ForEach(SelectedTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Divider()

                switch selectedTab {
                case .jeux:
                    GameListView()
                case .stocks:
                    StockView()
                }
            }
            .navigationTitle("Catalogue & Stocks")
        }.background(Color(UIColor.secondarySystemBackground))
    }
}
