//
//  FinancialInfoView.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 06.03.21.
//

import SwiftUI
import Combine

struct FinancialInfoView: View {
    
    @State var subscriptions: Set<AnyCancellable> = []
    
    @State var showLoginScreen = false
    @State var isLoggedIn = false
    @State var isLoading = false
    @State var showAlert = false
    
    @State var userInfo: UserInfoResponse?
    let api = SpaceTradersAPI.shared

    
    var body: some View {
            Form {
                Text("User Info")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .unredacted()
                Section(header: Text("UserInfo")) {
                    if isLoading {
                        ProgressView()
                    }
                    List {
                        Text("Username: \(self.userInfo?.user.username ?? "")" )
                        Text("Credits: \(self.userInfo?.user.credits ?? 0)")
                        Text("Ships: \(self.userInfo?.user.ships.count ?? 0)")
                        Text("Loans: \(self.userInfo?.user.loans.count ?? 0)")
                    }
                    .blur(radius: isLoading ?  /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/ : 0)
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Logged Out"), message: Text("The user info is no longer valid. Please log in again."), dismissButton: .default(Text("OK")) {
                    self.isLoggedIn = false
                    showLoginScreen = true

                })
            })
            .navigationBarTitle("Space Traders")
            .redacted(reason: .init(rawValue: isLoggedIn ? 0 : 1))
            .onAppear {
                if UserDefaults.standard.value(forKey: Constants.Defaults.token) == nil ||
                    UserDefaults.standard.value(forKey: Constants.Defaults.username) == nil {
                    self.showLoginScreen = true
                }
                else {
                    self.isLoggedIn = true
                    self.performUserInfoCall()
                }
            }
            .fullScreenCover(isPresented: $showLoginScreen, content: {
                LoginView()
            })
    
    }
    
    private func performUserInfoCall() {
        withAnimation {
            isLoading = true
        }
        if let username = UserDefaults.standard.string(forKey: Constants.Defaults.username),
           let token = UserDefaults.standard.string(forKey: Constants.Defaults.token) {
            self.api.getUserInfo(username: username, token: token)? //we call to get an optional AnyPublisher (which we have just prepared)
                .sink(receiveCompletion: { (completion) in //.sink is a Subscriber that waits until all data is delivered, as marked with the completion enum.
                    switch completion { //if we're finished, we can move to the next section
                    case .finished: break
                    case .failure(let error): //if an error was caught (e.g., JSON parsing), we handle it here.
                        print("\(error)")
                        isLoading = false
                        showAlert = true
                    }
                }, receiveValue: { (response) in //we get the response object from the Publisher, and can implement it in out view.
                    self.userInfo = response
                    withAnimation {
                        isLoading = false
                    }
                    
                })
                .store(in: &subscriptions) // the subscription to the Publisher is stored for later reuse - this also signifies the end of the data transaction. 
                
        }
        
        
    }
}

struct FinancialInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialInfoView()
    }
}
