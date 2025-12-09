//
//  CancellationView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/11/25.
//

import SwiftUI

struct ZoneCancellationView: View {
    
    @EnvironmentObject private var apiService: APIService
    
    @Binding var isPresented: Bool
    
    let location: String
    let tripId: String
    let reasons: [String]
    let sequence: Int
    
    @State var selectedReason: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading,  spacing: 40) {
            
            Text(LocalizedStringResource("please_select_the_cancellation_reason"))
                .font(Font.custom("ArialRoundedMTBold", size: 17.5))
            
            Divider()
            
            IconData(icon: "mappin", value: location)
        
            IconData(icon: "pencil.and.list.clipboard", value: "Select Reason")
            
            Picker("Select Reason", selection: $selectedReason) {
                
                ForEach(reasons, id: \.self) { reason in
                    Text(reason)
                }

                
            }
            .tint(.black)
            .padding(.vertical, 4)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            HStack(alignment: .center, spacing: 20) {
                
                Spacer()
                
                Button(LocalizedStringKey("close")) {
                    isPresented = false
                }
                
                Button(LocalizedStringKey("cancel_zone")) {
                    
                    Task {
                        do {
                            try await apiService.postCancelDeliveryTrip(geoZoneId: tripId, remarks: selectedReason, sequence: sequence)
                        } catch {
                            
                        }
                    }
                }
                .bold()
                .padding(.horizontal)
                .padding(.vertical, 6)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.red)
                )
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal)
        
        .onAppear {
            selectedReason = reasons.first ?? ""
        }
        
    }
    
}


#Preview {
//    CancellationView()
}
