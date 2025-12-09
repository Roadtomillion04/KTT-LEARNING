//
//  SettingViewHandler.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI

struct SettingViewHandler: View {
    
    @EnvironmentObject private var apiService: APIService
    @EnvironmentObject private var languageManager: LanguageManager
    
    @State var settingPath: SettingRoute
    
    var body: some View {
    
        switch settingPath {
            
        case .profile:
            
            ProfileView()
                .navigationTitle(LocalizedStringKey("profile"))
                            
        case .leaveRequest:
            
            LeaveRequestView()
                .navigationTitle(LocalizedStringKey("leave_request"))
                            
        case .leaveHistory:
            
            LeaveHistoryView()
                .navigationTitle(LocalizedStringKey("leave_history_list"))
            
        case .tripSettlement:
            
            TripSettlementView()
                .navigationTitle(LocalizedStringKey("trip_settlement"))
            
        case .documents:
            
            DocumentsView()
                .navigationTitle(LocalizedStringKey("documents"))

            
        case .attendance(.attendance):
            
            AttendanceView()
                .navigationTitle(LocalizedStringKey("mattendance"))
            
        case .attendance(.attendanceLogs):
            
            AttendanceLogView()
                .navigationTitle(LocalizedStringKey("attendance_logs_last_30_days"))
            
        case .attendance(.attendanceDetail(let data)):
            
            AttendanceDetailView(data: data)
                .navigationTitle(LocalizedStringKey("attendance_detail"))
            
        case .languages:
            
            LanguagesView()
                .navigationTitle(LocalizedStringKey("settings"))
        
        default:
            EmptyView()
            
        }
        
    }
}

#Preview {
//    SettingViewHandler()
}
