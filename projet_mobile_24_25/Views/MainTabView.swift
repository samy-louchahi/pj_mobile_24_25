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
            // Onglets pour les gestionnaires
            if auth.role == .gestionnaire {
                UserManagementView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Utilisateurs")
                    }
                GameListView()
                    .tabItem {
                        Image(systemName: "dice.fill")
                        Text("Jeux")
                    }
                DepotAndSaleManagerView()
                    .tabItem {
                        Image(systemName: "archivebox.fill")
                        Text("Dépôts et Ventes")
                    }

                StockView()
                    .tabItem {
                        Image(systemName: "shippingbox.fill")
                        Text("Stock")
                    }
            }

            // Onglets pour les admins
            if auth.role == .admin {
                SessionListView()
                    .tabItem {
                        Image(systemName: "cursorarrow.click.badge.clock")
                        Text("Sessions")
                    }

                GestionnaireListView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Gestionnaires")
                    }
            }

            // Onglets communs
            StatisticsTabView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Paramètres")
                }
        }
    }
}
