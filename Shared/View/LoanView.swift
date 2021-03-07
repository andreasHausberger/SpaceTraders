//
//  LoanView.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 06.03.21.
//

import SwiftUI
import Combine

struct LoanView: View {
    let api = SpaceTradersAPI.shared
    @State var availableLoans: [Loan] = [Loan]()
    @State var subscriptions: Set<AnyCancellable> = []
    @State var isLoading = false
    var body: some View {
        Form {
            Text("Loans")
                .font(.largeTitle)
                .fontWeight(.bold)
            Section(header: Text("Available Loans")) {
                if (isLoading) {
                    ProgressView()
                }
                else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            ForEach(0..<availableLoans.count) { index in
                                let loan = availableLoans[index]
                                LoanCard(loan: loan)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 10)
                                    .frame(width: UIScreen.main.bounds.width * 0.75)
                            }
                        }
                    }
                    
                }
            }
        }
        .onAppear {
            self.getAvailableLoans()
        }
    }
    
    private func getAvailableLoans() {
        withAnimation {
            isLoading = true
        }
        api.getAvailableLoans()?
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished: break
                case .failure(_):
                    withAnimation {
                        isLoading = false
                    }
                }
            }, receiveValue: { (response) in
                self.availableLoans = response.loans
                withAnimation {
                    isLoading = false
                }
            })
            .store(in: &subscriptions)
    }
    
    private func applyForLoan() {
        withAnimation { isLoading = true }
        
    }
}

struct LoanCard: View {
    @State var loan: Loan
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
            HStack {
                VStack {
                    Text(loan.type)
                        .fontWeight(.bold)
                        .font(.title2)
                    Divider()
                    Text("Amount: \(loan.amount)")
                    Text("Rate: \(loan.rate)")
                    Text("Term in \(loan.termInDays) days")
                    Divider()
                    Text("Collateral:")
                    Image(systemName: loan.collateralRequired ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(loan.collateralRequired ? .red : .green)
                }
            }
            .padding(25)
        }
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleLoan = Loan(type: "STARTUP", amount: 1000, rate: 8.76, termInDays: 10, collateralRequired: false)
        LoanView(availableLoans: [exampleLoan, exampleLoan])
    }
}
