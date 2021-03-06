//
//  GameView.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 05.03.21.
//

import SwiftUI
import Combine

struct GameView: View {
    
    let api = SpaceTradersAPI.shared
    
    var subscriptions: Set<AnyCancellable> = []
    
    @State var showLoginScreen = false
    @State var isLoggedIn = false
    
    @State var userInfo: UserInfoResponse?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("UserInfo")) {
                    List {
                
                    }
                }
            }
            .navigationTitle("Space Traders")
            .redacted(reason: .init(rawValue: isLoggedIn ? 0 : 1))
        }
        
            .onAppear {
                if UserDefaults.standard.value(forKey: Constants.Defaults.token) == nil ||
                    UserDefaults.standard.value(forKey: Constants.Defaults.username) == nil {
                    self.showLoginScreen = true
                }
                else {
                    self.isLoggedIn = true
                }
            }
            .fullScreenCover(isPresented: $showLoginScreen, content: {
                LoginView()
            })
    }
    
    private func performUserInfoCall() {
        let username = UserDefaults.standard.value(forKey: Constants.Defaults.username)
        let token = UserDefaults.standard.value(forKey: Constants.Defaults.token)
        
        
    }
}
