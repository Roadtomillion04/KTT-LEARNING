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
        
        VStack {
            
            Form {
                
                Picker("Select Reason", selection: $vm.reason) {
                    
                    ForEach(vm.leaveReasons, id: \.id) { reason in
                        Text(reason.text ?? "")
                            .tag(reason.id ?? "")
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                }
                
                // 30 days from today only as per app
                DatePicker(LocalizedStringKey("from_date"), selection: $vm.fromDate, in: Date()...Date().addingTimeInterval(60*60*24*30), displayedComponents: .date)
                
                    .onChange(of: vm.fromDate) { old, new in
                        vm.updateButtonText(new, vm.toDate)
                    }
                
                
                DatePicker(LocalizedStringKey("to_date"), selection: $vm.toDate, in: Date()...Date().addingTimeInterval(60*60*24*30), displayedComponents: .date)
                
                    .onChange(of: vm.toDate) { old, new in
                        vm.updateButtonText(vm.fromDate, new)
                    }
                
                TextField(LocalizedStringKey("comments"), text: $vm.comment, axis: .vertical)
                
                
            }
            .font(Font.custom("Monaco", size: 12.5))
            
            .task {
                await vm.onAppear(apiService)
            }
            
            
            Button {
                Task {
                    await vm.postLeaveRequest(apiService)
                }
            } label: {
                Text(vm.buttonText)
                    .modifier(SaveButtonModifier())
                    .padding(.horizontal)
            }
            
        }
        .ignoresSafeArea(.keyboard)
        
        .toast(message: $vm.toastMessage)
        
        .toolbar {
            
            ToolbarItem(placement: .keyboard) {
                    
                Button("done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
    
}


fileprivate class LeaveRequestViewModel: ObservableObject {
   
    @Published var fromDate: Date = Date()
    @Published var toDate: Date = Date()
    @Published var comment: String = ""
    @Published var buttonText: String
    
    private var days: Int = 1
    
    @Published var leaveReasons: [APIService.LeaveReasonModel.Reasons] = []
    @Published var reason: String = ""
    
    enum FieldValidation: String {
        case invalidDateRange = "Invalid Date Range"
        case remarks = "Enter Remarks"
    }
    
    @Published var toastMessage: String?
    
    init() {
        self.buttonText = "APPLY FOR \(days) DAYS LEAVE"
    }
    
    @MainActor
    func onAppear(_ apiService: APIService) async {
        do {
            leaveReasons = try await apiService.getDriverLeaveReasons()
            reason = leaveReasons.first?.text ?? ""
            
            print(leaveReasons)
        } catch {
            
        }
    }
    
    func updateButtonText(_ startDate: Date, _ endDate: Date) {
        
        days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        
        buttonText = "APPLY FOR \(days) DAYS LEAVE"
    }
        
    func postLeaveRequest(_ apiService: APIService) async {
        
        if comment.isEmpty {
            toastMessage = FieldValidation.remarks.rawValue
            return
        }
        
        do {
            try await apiService.postDriverLeave(fromDate: fromDate.toString(format: "dd/MM/yyyy"), reason: reason, toDate: toDate.toString(format: "dd/MM/yyyy"), remarks: comment)
        } catch {
            
        }
         
    }
    
}

// Model
extension APIService {
    
    struct LeaveReasonModel: Decodable {
        var success: Bool?
        var reasons: [Reasons] = []
        var error: String?
        
        struct Reasons: Hashable, Decodable { // Hashable for iteration in ForEach
            var id: String?
            var text: String?
        }
    }
    
}

#Preview {
//    LeaveRequestView()
}

