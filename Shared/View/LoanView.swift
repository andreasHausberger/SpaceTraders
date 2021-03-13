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
    var body: some View {
        NavigationView {
        Form {
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
                                    .onTapGesture {
                                        self.selectedLoan = loan
                                    }
                                
                            }
                        }
                    }
                    
                }
            }
        }
        .navigationTitle("Loans")
        }
        .sheet(item: $selectedLoan, content: { (loan) in
            LoanDetailView(loan: loan)
        })
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
            .padding(25)
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

struct LoanDetailView: View {
    @State var loan: AvailableLoan
    @State var subscriptions: Set<AnyCancellable> = []
    @State var isSuccessful = false
    var body: some View {
        Text("Selected Loan")
            .font(.largeTitle)
            .fontWeight(.bold)
        LoanCard(loan: loan)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: 400)
        Divider()
        HStack {
            Spacer()
            SpacyButton(color: .green, textColor: .white, image: nil, text: "Take Out Loan", action: {
                takeOutLoan()
            })
            Spacer()
            
            if (isSuccessful) {
                Text("Success!")
            }
        }
        
        
    }
    
    private func takeOutLoan() {
        SpaceTradersAPI.shared.applyForLoan(loanType: self.loan.type)?
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { (response) in
                isSuccessful.toggle()
                print("response: \(response)")
            })
            .store(in: &subscriptions)
    }
}

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleLoan = AvailableLoan(type: "STARTUP", amount: 1000, rate: 8.76, termInDays: 10, collateralRequired: false)
        LoanView(availableLoans: [exampleLoan, exampleLoan])
    }
}
