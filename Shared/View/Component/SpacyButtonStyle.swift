//
//  SpacyButton.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 06.03.21.
//

import SwiftUI

struct SpacyButtonStyle: ButtonStyle {
    var color: Color
    var textColor: Color? = .white
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(textColor)
            .padding(.horizontal, 32)
            .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .background(color)
            .cornerRadius(10)
            .opacity(isEnabled ? 1.0 : 0.45)
            .shadow(radius: 5)
    }
}

struct SpacyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Button") {
                return
            }
            .buttonStyle(SpacyButtonStyle(color: Color.green))
            Button("Button") {
                return
            }
            .buttonStyle(SpacyButtonStyle(color: Color.black))
            Button("Button") {
                return
            }
            .buttonStyle(SpacyButtonStyle(color: Color.black))
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
    }
}
