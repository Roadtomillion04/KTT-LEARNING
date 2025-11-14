//
//  SettingViewHandler.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI

struct SettingViewHandler: View {
    
    @EnvironmentObject private var apiService: APIService
    
    @State var settingPath: SettingRoute
    
    var body: some View {
    
        switch settingPath {
            
        case .profile:
            
            ProfileView()
                .navigationTitle("Profile")
                .task {
                    do {
                        try await apiService.getProfileSummary()
                    } catch {
                        
                    }
                }
            
        case .leaveRequest:
            
            LeaveRequestView()
                .navigationTitle("Leave Request")
                .task {
                    apiService.getDriverLeaveReasons()
                }
            
        case .leaveHistory:
            
            LeaveHistoryView()
                .navigationTitle("Leave History")
            
        case .tripSettlement:
            
            TripSettlementView()
                .navigationTitle("Trip Settlement")
            
        case .documents:
            
            DocumentsView()
                .navigationTitle("Documents")
                .task {
                    
                    do {
                        try await apiService.getDriverDocuments()
                    } catch {
                        
                    }
                    
                }
            
        case .attendance(.attendance):
            
            AttendanceView()
                .navigationTitle("Attendance")
                .task {
                    do {
                        try await apiService.getDriverCheckIn()
                    } catch {
                        
                    }
                }
            
        case .attendance(.attendanceLogs):
            
            AttendanceLogView()
                .navigationTitle("Attendance Logs (Last 30 Days)")
            
        case .attendance(.attendanceDetail(let data)):
            
            AttendanceDetailView(data: data)
                .navigationTitle("Attendance Detail")
            
        case .languages:
            
            LanguagesView()
                .navigationTitle("Language Settings")
        
        default:
            EmptyView()
            
        }
        
    }
}

#Preview {
//    SettingViewHandler()
}
