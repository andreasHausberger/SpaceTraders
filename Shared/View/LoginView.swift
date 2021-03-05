//
//  LoginView.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 05.03.21.
//

import SwiftUI
import Combine

struct LoginView: View {
    @State var userName: String = ""
    @State var token: String = ""
    
    @State var status: StatusResponse?
    @State var usernameResponse: UsernameResponse?
    @State var userInfoResponse: UserInfoResponse?
    
    @State var subscriptions: Set<AnyCancellable> = []
    @State var error: APIError?
    @State var showAlert: Bool = false
    @State var redactInfo: Bool = true
    
    let api = SpaceTradersAPI.shared
    let storage = Storage.shared
    
    var body: some View {
        VStack {
            Text("Welcome to SpaceTraders! 🖖")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Form {
                Section(header: Text("Login/Signup")) {
                    TextField("Username", text: $userName)
                    Text("Already have your token? Enter it below!")
                        .font(.footnote)
                    TextField("Token", text: $token)
                    
                  
                        Button(action: {
                            self.performUsernameCall()
                        }, label: {
                            Text("Claim Username")
                        })
                        .background(Color.green)
                        .foregroundColor(.white)
                        Button(action: {
                            self.performUserInfoCall()
                        }, label: {
                            Text("Login")
                        })
                        
                        Button(action: {
                            if let token = UserDefaults.standard.string(forKey: Constants.Defaults.token) {
                                self.token = token
                            }
                        }, label: {
                                Text("Use Saved Token")
                        })
                        .background(Color.purple)
                        .foregroundColor(.white)
                       
                }
                Section(header: Text("Game Status")) {
                    Text(status?.status ?? "No Status")
                        .font(.subheadline)
                }
                Section(header: Text("Your User Info")) {
                    List {
                        Text("Username: \(userInfoResponse?.user.username ?? "")")
                        Text("Credits: \(userInfoResponse?.user.credits ?? 0)")
                    }
                    .redacted(reason: .init(rawValue: redactInfo ? 1 : 0))
                    
                }
            }
        }
        .onAppear {
            self.performStatusCall()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error"), message: Text("This username has been claimed already"))
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
        let username = userName
        let token = UserDefaults.standard.string(forKey: Constants.Defaults.token) ?? self.token
        if self.token != "" {
            self.api.getUserInfo(username: username, token: token)?
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.showAlert.toggle()
                        self.error = error
                    }
                }, receiveValue: { response in
                    UserDefaults.standard.setValue(self.token, forKey: Constants.Defaults.token)
                    self.userInfoResponse = response
                    self.redactInfo.toggle()
                    hideKeyboard()
                })
                .store(in: &subscriptions)
        }
           
    }
    
    private func performUsernameCall() {
        self.api.postUsername(username: userName)?
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
            })
            .store(in: &subscriptions)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
