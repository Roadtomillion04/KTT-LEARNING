//
//  DatePickerView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 02/12/25.
//

import SwiftUI

struct DatePickerView: View {
    
    @StateObject var vm: TripsViewModel
    @EnvironmentObject var apiService: APIService
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                Text(LocalizedStringResource("from_date"))
                    .font(Font.custom("ArialRoundedMTBold", size: 14))
                
                DatePicker("From", selection: $vm.startDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                
                    .onChange(of: vm.startDate) { old, new in
                        if new >= vm.endDate {
                            vm.startDate = old
                        }
                        
                    }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
            
            VStack {
                
                Text(LocalizedStringResource("to_date"))
                    .font(Font.custom("ArialRoundedMTBold", size: 14))
                
                DatePicker("To", selection: $vm.endDate, in: vm.startDate...Date().addingTimeInterval(60*60*24*30*12*1),  displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
            
            
            Button {
                vm.showDatePicker = false
                Task {
                    await vm.onAppear(apiService: apiService)
                }
            } label: {
                Text("confirm")
                    .modifier(SaveButtonModifier())
            }
            
            
        }
            
        
    }
    
}

#Preview {
//    DatePickerView()
}
