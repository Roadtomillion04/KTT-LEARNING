//
//  TripAdvanceView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 04/09/25.
//

import SwiftUI

struct TripAdvanceView: View {
    
    let data: [APIService.TripsDataModel.TripAdvance]
    
    let columns = [
                GridItem(.flexible(), spacing: 40),
                GridItem(.flexible())
            ]
    
    var body: some View {

        List {
        
            ForEach(data, id: \.id) { advance in

                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 25) {
 
                    IconData(icon: "square.stack", title: "Advance Level", value: "\(advance.advLevel ?? 0)")
                    
                    IconData(icon: "fuelpump.fill", title: "Fuel Liter", value: "\(advance.breakup?.fuelLiters ?? 0)")
                    
                    IconData(icon: "fuelpump.exclamationmark.fill", title: "Fuel Amount", value: "\(advance.breakup?.fuel ?? 0)")
                    
                    IconData(icon: "fuelpump", title: "Toll", value: "\(advance.breakup?.toll ?? 0)")
                    
                    IconData(icon: "indianrupeesign", title: "Cash", value: "\(advance.breakup?.cash ?? 0)")
                    
                    IconData(icon: "creditcard.fill", title: "ATM", value: "\(advance.breakup?.atm ?? 0)")
                    
                    IconData(icon: "pencil.and.list.clipboard", title: "Payment Status", value: TripStatusHandler.paymentStatusText(advance.status ?? 0))
                    
                    IconData(icon: "calendar", title: "Date & Time", value: advance.paidDate?.dateFormatting(format: "dd/MM/yyyy") ?? "-")
                    
                    IconData(icon: "newspaper.fill", title: "Voucher Number", value: advance.voucherNo ?? "")
                    
                    IconData(icon: "banknote.fill", title: "Amount", value: advance.totalAmount ?? "")
                
                }
                .padding(.vertical)
            }
            
        }
        .listRowSpacing(15)
        .shadow(radius: 2)
        
        // if data is empty, no record alert
        .onAppear {
            if data.isEmpty {
            
            }
        }
        
    }
}

#Preview {
//    TripAdvanceView()
}
