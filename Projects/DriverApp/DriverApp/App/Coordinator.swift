//
//  Coordinator.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import Foundation
import SwiftUI


enum Route: Hashable {
    case login
    case home(HomeTab)
    case trips(TripRoute)
    case dashboard(DashboardRoute)
    case setting(SettingRoute)
    case miscellaneous(MiscellaneousRoute)
}

enum HomeTab: Hashable, CaseIterable { 
    case poi
    case trips
    case dashboard
    case settings
}

enum TripRoute: Hashable {
    case tripExpenses(TripExpensesRoute)
    case tripAdvances(advanceData: [APIService.TripsDataModel.TripAdvance])
}

// start and end date for keeping track
enum TripExpensesRoute: Hashable {
    case tripExpenses(tripId: Int, assetId: Int, startDate: String, endDate: String)
    case addTripsExpenses(isEditing: Bool, expenseId: Int? = nil, tripId: Int, assetId: Int, startDate: String, endDate: String)
}


enum DashboardRoute: Hashable {
    static func == (lhs: DashboardRoute, rhs: DashboardRoute) -> Bool {
        return true
    }
    
    // replacing bottom sheet
    case zoneInfo(location: String, date: String, lrNumber: String, loadingCharges: String, unloadingCharges: String, lrImage: [APIService.DriverStatusModel.ImageShare], podImage: [APIService.DriverStatusModel.ImageShare], docImage: [APIService.DriverStatusModel.ImageShare])
    
    case lrUpload(id: String, lr: APIService.DriverStatusModel.ShareImages)
    case podUpload(id: String, pod: APIService.DriverStatusModel.ShareImages)
    case docUpload(id: String, doc: [APIService.DriverStatusModel.ImageShare])
    case operationgExpenses(id: String, opExpenses: Trip.OpExpenses)
}

enum SettingRoute: Hashable {
    case profile
    case leaveRequest
    case leaveHistory
    case tripSettlement
    case documents
    case attendance(AttendanceRoute)
    case languages
    case privacyPolicy
    case logout
}


enum AttendanceRoute: Hashable {
    case attendance
    case attendanceLogs
    case attendanceDetail(data: APIService.DriverCheckInModel.Results)
}

enum MiscellaneousRoute: Hashable, Equatable {
    
    // Binding needs to conform Equatable, so again empty stubs to ignore
    static func == (lhs: MiscellaneousRoute, rhs: MiscellaneousRoute) -> Bool {
        return true
    }
    
    
    // Image does not conform Hashable, empty stubs fix 
    func hash(into hasher: inout Hasher) {
        
       }
    
    case imageViewer(image: Image)
    
    case pdfViewer(url: String)
    
    case cameraCapture(image: Binding<UIImage>, sourceType: UIImagePickerController.SourceType)
}

final class AppCoordinator: ObservableObject {
    
    @Published var path: [Route] = []
    @Published var selectedTab: HomeTab = .dashboard
    
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }
    
    func reset() {
        path.removeAll()
        self.push(.login)
    }

}

