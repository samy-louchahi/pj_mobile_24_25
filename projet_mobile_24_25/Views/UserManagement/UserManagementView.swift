//
//  UserManagementView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct UserManagementView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack {
                Picker("Choix", selection: $selectedTab) {
                    Text("Acheteurs").tag(0)
                    Text("Vendeurs").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    BuyerSectionView()
                } else {
                    SellerSectionView()
                }
            }
            .navigationTitle("Gestion des Utilisateurs")
        }
    }
}