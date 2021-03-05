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
    @State var subscriptions: Set<AnyCancellable> = []
    let api = SpaceTradersAPI.shared
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
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.performStatusCall()
                        }, label: {
                            Text("Login")
                        })
                        .background(Color.green)
                        .foregroundColor(.white)
                        
                        Button(action: {}, label: {
                                Text("Use Saved Token")
                        })
                        .background(Color.purple)
                        .foregroundColor(.white)
                        Spacer()
                    }
                }
                Section(header: Text("Game Status")) {
                    Text(status?.status ?? "No Status")
                        .font(.subheadline)
                }
            }
        }
        .onAppear {
            self.performStatusCall()
        }
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
