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
    @State var availableLoans: [AvailableLoan] = [AvailableLoan]()
    @State var subscriptions: Set<AnyCancellable> = []
    @State var isLoading = false
    @State var selectedLoan: AvailableLoan?
    @State var displaySheet = false
    @State var takeOutLoanIsSuccessful = false
    
    var body: some View {
        NavigationView {
        Form {
            Section(header: Text("Available Loans")) {
                Group {
                    if (isLoading) {
                        ProgressView()
                            .scaledToFit()
                    }
                    else {
                        TabView(selection: $selectedLoan) {
                            ForEach(0..<availableLoans.count) { index in
                                let loan = availableLoans[index]
                                LoanCard(loan: loan)
                                    .padding(.top, 25.0)
                                    .frame(width: 250.0, height: 150, alignment: .bottom)
                                    .tag(loan)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    }
                }
                .frame(minWidth: 250.0, maxWidth: .infinity, idealHeight: 300.0)
                Button("Take Out Loan", action: {
                    takeOutLoan(selectedLoan!)
                })
                .buttonStyle(SpacyButtonStyle(color: .green))
                .disabled(selectedLoan == nil)
                
                if (takeOutLoanIsSuccessful) {
                    Text("Success!")
                }
                
            }
        }
        .navigationTitle("Loans")
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
    
    private func takeOutLoan(_ loan: AvailableLoan) {
        SpaceTradersAPI.shared.applyForLoan(loanType: loan.type)?
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { (response) in
                self.takeOutLoanIsSuccessful.toggle()
                print("response: \(response)")
            })
            .store(in: &subscriptions)
    }
}

struct LoanCard: View {
    @State var loan: AvailableLoan
    
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


struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleLoan = AvailableLoan(type: "STARTUP", amount: 1000, rate: 8.76, termInDays: 10, collateralRequired: false)
        let exampleLoan1 = AvailableLoan(type: "TEST1", amount: 1100, rate: 9.87, termInDays: 3, collateralRequired: true)
        LoanView(availableLoans: [exampleLoan, exampleLoan1])
    }
}
