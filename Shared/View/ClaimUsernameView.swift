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
        Form {
            Section {
                TextField("Claim a new Username", text: $newUsername)
                SpacyButton(color: .black) {
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
                        })
                        .store(in: &subscriptions)
                    
                }
                HStack {
                    Text("Availability: ")
                
                }
                
            }
        }
        .navigationTitle("Claim Username")
        
    }
}

struct ClaimUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimUsernameView()
    }
}
