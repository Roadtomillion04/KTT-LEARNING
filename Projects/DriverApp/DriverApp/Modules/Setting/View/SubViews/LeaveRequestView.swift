//
//  LeaveRequestView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 02/09/25.
//

import SwiftUI


struct LeaveRequestView: View {
    
    @StateObject private var vm: LeaveRequestViewModel = .init()
    
    @EnvironmentObject private var apiService: APIService
    
    
    var body: some View {
        
        Form {
            
            Picker("Select Reason", selection: $vm.reason) {
                
                Text("None") // None option
                    .tag(nil as String?)
                
                ForEach(apiService.leaveReasonAttributes.reasons, id: \.id) { reason in
                    Text(reason.text ?? "")
                        .tag(reason.id)
                }
            }
            
            // 30 days from today only as per app
            DatePicker("From Date", selection: $vm.fromDate, in: Date()...Date().addingTimeInterval(60*60*24*30), displayedComponents: .date)
                
                .onChange(of: vm.fromDate) { old, new in
                    vm.updateButtonText(new, vm.toDate)
                }
            
            
            DatePicker("To Date", selection: $vm.toDate, in: Date()...Date().addingTimeInterval(60*60*24*30),  displayedComponents: .date)
            
                .onChange(of: vm.toDate) { old, new in
                    vm.updateButtonText(vm.fromDate, new)
                }
            
            
            TextField("Comments", text: $vm.comment, axis: .vertical)
                .font(Font.custom("Monaco", size: 16))
                            
        }
          
        Button {
            
        } label: {
            Text(vm.buttonText)
                .modifier(SaveButtonModifier())
                .padding(.horizontal)
        }
    }
    
}


fileprivate class LeaveRequestViewModel: ObservableObject {
   
    @Published var fromDate: Date = Date()
    @Published var toDate: Date = Date()
    @Published var comment: String = ""
    @Published var buttonText: String
    
    private var days: Int = 0
    
    
    @Published var reason: String?
    
    
    init() {
        self.buttonText = "APPLY FOR \(days) DAYS LEAVE"
    }
    
    func updateButtonText(_ startDate: Date, _ endDate: Date) {
        
        days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        
        buttonText = "APPLY FOR \(days) DAYS LEAVE"
    }
        
}

#Preview {
//    LeaveRequestView()
}
