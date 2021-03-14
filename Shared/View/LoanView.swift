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
    @State var selectedLoanIndex: Int = 0
    var selectedLoan: AvailableLoan {
        availableLoans[selectedLoanIndex]
    }
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
                        TabView(selection: $selectedLoanIndex) {
                            ForEach(0..<availableLoans.count) { index in
                                let loan = availableLoans[index]
                                LoanCardView(loan: loan)
                                    .padding(.top, 25.0)
                                    .frame(width: 250.0, height: 150, alignment: .bottom)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    }
                }
                .frame(minWidth: 250.0, maxWidth: .infinity, idealHeight: 300.0)
                Button("Take Out Loan", action: {
                    takeOutLoan(selectedLoan)
                })
                .buttonStyle(SpacyButtonStyle(color: .green))
                .disabled(isLoading || availableLoans.isEmpty)
                
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

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleLoan = AvailableLoan(type: "STARTUP", amount: 1000, rate: 8.76, termInDays: 10, collateralRequired: false)
        let exampleLoan1 = AvailableLoan(type: "TEST1", amount: 1100, rate: 9.87, termInDays: 3, collateralRequired: true)
        LoanView(availableLoans: [exampleLoan, exampleLoan1])
    }
}
