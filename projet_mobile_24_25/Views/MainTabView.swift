//
//  MainTabView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        TabView {
            BuyerListView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Acheteurs")
                }

            SellerListView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Vendeurs")
                }
            GameListView()
                .tabItem {
                    Image(systemName: "dice.fill")
                    Text("Jeux")
                }
            SessionListView()
                .tabItem {
                    Image(systemName: "cursorarrow.click.badge.clock")
                    Text("Sessions")
                }
            DepositListView()
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("Dépôts")
                }
            // etc.
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    auth.logout()
                }
            }
        }
    }
}
