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
            FinancialInfoView()
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
