//
//  ClaimUsernameView.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 06.03.21.
//

import SwiftUI
import Combine

struct ClaimUsernameView: View {
    @State var newUsername = ""
    @State var subscriptions: Set<AnyCancellable> = []
    @State var postUsernameResponse: UsernameResponse?
    @State var isAvailable: Bool = false
    
    let api = SpaceTradersAPI.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Claim a new Username", text: $newUsername)
                        .autocapitalization(.none)
                    HStack {
                        Spacer()
                        SpacyButton(color: .black, text: "Claim") {
                            self.claimUsername()
                        }
                        Spacer()
                    }
                    
                    VStack {
                        Text("Availability: \(self.isAvailable ? "Available" : "Unavailable")")
                        if (self.isAvailable) {
                            Text("Username secured. Token: \(postUsernameResponse?.token ?? "")")
                        }
                    }
                }
            }
            .navigationTitle("Claim Username")
        }
        
    }
    
    private func claimUsername() {
        api.postUsername(username: newUsername)?
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished: break

                case .failure(let error):
                    print("Error \(error)")
                    self.isAvailable = false
                }
            }, receiveValue: { (response) in
                self.postUsernameResponse = response
                self.isAvailable = true
                Storage.login(username: response.user.username, token: response.token)
            })
            .store(in: &subscriptions)
    }
}

struct ClaimUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimUsernameView()
    }
}
