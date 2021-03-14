//
//  GameView.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 05.03.21.
//

import SwiftUI
import Combine

struct GameView: View {
    
    
   
    var body: some View {
        TabView {
            UserInfoView()
                .tabItem {
                    Label("Info", systemImage: "person.fill")
                }
            Text("Ships")
                .tabItem { Label("Ships", systemImage: "location.north.fill") }
            Text("Trade")
                .tabItem { Label("Trade", systemImage: "bag.fill") }
            LoanView()
                .tabItem { Label("Loans", systemImage: "dollarsign.circle") }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
