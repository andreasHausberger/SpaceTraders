//
//  LoginView.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 05.03.21.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var username: String = ""
    @State var token: String = ""
    
    @State var status: StatusResponse?
    @State var usernameResponse: UsernameResponse?
    @State var userInfoResponse: UserInfoResponse?
    
    @State var subscriptions: Set<AnyCancellable> = []
    @State var error: APIError?
    @State var redactInfo: Bool = true
    
    @State var showAlert: Bool = false
    @State var showSheet: Bool = false
    @State var showProgress: Bool = false

    
    let api = SpaceTradersAPI.shared
    let storage = Storage.shared
    
    var body: some View {
        VStack {
            Text("Welcome to SpaceTraders! 🖖")
                .font(.largeTitle)
                .fontWeight(.bold)
            ZStack {
                Form {
                    Section(header: Text("Login/Signup")) {
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                        TextField("Token", text: $token)
                        List {
                            Button("Login") {
                                self.performUserInfoCall()
                            }
                            Button("Insert Saved Token") {
                                if let token = UserDefaults.standard.string(forKey: Constants.Defaults.token) {
                                    self.token = token
                                }
                            }
                            Button("Claim New Username") {
                                self.showSheet.toggle()
                            }
                        }
                        
                    }
                    Section(header: Text("Game Status")) {
                        Text(status?.status ?? "No Status")
                            .font(.subheadline)
                    }
                }
                .blur(radius: self.showProgress ? 3.0 : 0)
                if showProgress {
                    ProgressView("Loading")
                }
                
            }
           
        }
        .onAppear {
            self.performStatusCall()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error"), message: Text("This username has been claimed already"))
        })
        .sheet(isPresented: $showSheet, onDismiss: {
            if let loginData = Storage.getUsernameAndToken() {
                self.username = loginData.username
                self.token = loginData.token
            }
        }, content: {
            ClaimUsernameView()
        })
        
    }
    
    private func performStatusCall() {
        self.api.getStatus()?
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                  print("Error: \(error)")
                }
            }, receiveValue: { response in
                self.status = response
            })
            .store(in: &subscriptions)
    }
    
    private func performUserInfoCall() {
        withAnimation(.easeInOut) {
            self.showProgress.toggle()
        }
        
        let token = UserDefaults.standard.string(forKey: Constants.Defaults.token) ?? self.token
        if self.token != "" {
            self.api.getUserInfo(username: username, token: token)?
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.showAlert.toggle()
                        self.error = error
                        self.showProgress = false
                    }
                }, receiveValue: { response in
                    UserDefaults.standard.setValue(self.token, forKey: Constants.Defaults.token)
                    UserDefaults.standard.setValue(self.username, forKey: Constants.Defaults.username)

                    self.userInfoResponse = response
                    self.redactInfo.toggle()
                    hideKeyboard()
                    self.showProgress = false
                    self.presentationMode.wrappedValue.dismiss()
                })
                .store(in: &subscriptions)
        }
           
    }
    
    private func performUsernameCall() {
        self.api.postUsername(username: username)?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                  print("Error: \(error)")
                    self.showAlert.toggle()
                    self.error = error
                }
            }, receiveValue: { response in
                self.usernameResponse = response
                token = response.token
                UserDefaults.standard.setValue(response.token, forKey: Constants.Defaults.token)
                UserDefaults.standard.setValue(response.user.username, forKey: Constants.Defaults.username)
            })
            .store(in: &subscriptions)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
