//
//  LoanCardView.swift
//  SpaceTraders
//
//  Created by AndiCui on 14.03.21.
//

import SwiftUI

struct LoanCardView: View {
    @State var loan: AvailableLoan
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.secondary)
            HStack {
                VStack {
                    Text(loan.type)
                        .fontWeight(.bold)
                        .font(.title2)
                    Divider()
                    Text("Amount: \(loan.formattedAmount)")
                    Text("Rate: \(loan.formattedRate)")
                    Text("Term in \(loan.termInDays) days")
                    Divider()
                    Text("Collateral:")
                    Image(systemName: loan.collateralRequired ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(loan.collateralRequired ? .red : .green)
                }
            }
            .padding(15.0)
        }
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

// Extension to format numbers for loan cards
private extension AvailableLoan {
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self.amount))!
    }
    
    var formattedRate: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self.rate))!
    }
}

struct LoanCardView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleLoan = AvailableLoan(type: "STARTUP", amount: 1000, rate: 8.76, termInDays: 10, collateralRequired: false)
        LoanCardView(loan: exampleLoan)
            .padding(50)
    }
}
