//
//  MainTabView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//
import SwiftUI

struct MainTabView: View {
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

            StockView()
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Stock")
                }

            SaleView()
                .tabItem {
                    Image(systemName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                    Text("Ventes")
                }
            GestionnaireListView()
                .tabItem{
                    Image(systemName: "person.fill")
                    Text("Gestionnaires")
            }
            StatisticsTabView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
            SettingsView() // 👉 on ajoute une tab pour la déconnexion
                .tabItem {
                    Image(systemName: "gear")
                    Text("Paramètres")
                }
        }
    }
}
