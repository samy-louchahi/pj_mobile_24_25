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
        if authViewModel.isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}
