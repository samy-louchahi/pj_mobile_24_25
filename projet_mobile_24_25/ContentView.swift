//
//  ContentView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 11/03/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            if authViewModel.isLoggedIn {
                MainTabView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: authViewModel.isLoggedIn)
    }
}
