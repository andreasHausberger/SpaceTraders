//
//  SpacyButton.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 06.03.21.
//

import SwiftUI

struct SpacyButton: View {
    var color: Color
    var textColor: Color? = .white
    var image: Image?
    var text: String?
    var action: () -> Void
    var body: some View {
        
        Button(action: action, label: {
            Text("\(text?.uppercased() ?? "BUTTON")")
                .foregroundColor(textColor)
                .padding(.horizontal, 32)
                .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .background(color)
                .cornerRadius(10)
                
        })
        .shadow(radius: 5)
    }
}

struct SpacyButton_Previews: PreviewProvider {
    static var previews: some View {
        SpacyButton(color: .green) {
            print("Example")
        }
    }
}
