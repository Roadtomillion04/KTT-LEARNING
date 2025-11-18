//
//  Tripsvm.swift
//  DriverApp
//
//  Created by Nirmal kumar on 04/09/25.
//

import Foundation
import SwiftUI

struct TripStatusHandler {
    
    static func statusText(_ status: Int) -> String {
        
        switch status {
            
        case 0:
            return "Loading"
            
        case 1:
            return "Transit"
            
        case 2:
            return "Unloading"
            
        case 3:
            return "Unloaded"
            
        case 4:
            return "Completed"
            
        default:
            return ""
            
        }
        
    }
    
    static func statusAccountText(_ statusAccounts: Int) -> String {
        
        switch statusAccounts {
            
        case 0:
            return "Unverfied"
            
        case 1:
            return "Verfied"
            
        case 2:
            return "Approved"
            
        case 3:
            return "Settled"
            
        case 4:
            return "Rejected"
            
        default:
            return ""
            
        }
        
    }
    
    static func paymentStatusText(_ status: Int) -> String {
        
        switch status {
            
        case 0:
            return "Pending" // not sure what comes here
            
        case 1:
            return "Approved"
            
        case 2:
            return "Paid"
            
        case 3:
            return "Rejected"
            
        default:
            return ""
            
        }
    }
    
}


class TripsViewModel: ObservableObject {
    
    @Published var startDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    @Published var endDate: Date = Date()

    
    let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]

    // works but icrementing it via looping is not ideal, back to storing in api response
    
//    func totalAdvances(_ tripsResult: [APIService.TripsDataAttributes.Results]) -> String {
//        
//        var total: Double = 0
//        
//        for result in tripsResult {
//            total += result.tripAdvances.filter( { $0.status == 2 } ).map( { Double($0.totalAmount ?? "") ?? 0  } ).reduce(0, +)
//        }
//        
//        return total.round()
//        
//    }
//    
//    func totalExpenses(_ tripsResult: [APIService.TripsDataAttributes.Results]) -> String {
//        
//        var total: Double = 0
//        
//        for result in tripsResult {
//            total += result.tripExpenses.map( { Double($0.amount ?? "") ?? 0  } ).reduce(0, +)
//        }
//        
//        return total.round()
//        
//    }
    
    func onAppear(apiService: APIService, cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) async {
        do {
            try await apiService.getTripsData(cachePolicy: cachePolicy)
        } catch {
            
        }
    }
    
    
    func calculateAdvance(_ tripAdvance: [APIService.TripsDataAttributes.TripAdvance]) -> String {
        
        return tripAdvance.map( { $0.totalAmount?.toDouble() ?? 0 } ).reduce(0, +).round()
        
    }
    
    func approvedExpense(_ tripExpense: [APIService.TripsDataAttributes.TripExpense]) -> String {
        
        return tripExpense.filter( { $0.status == 1 } ).map( { $0.amount?.toDouble() ?? 0 } ).reduce(0, +).round()
    }
    
    func pendingExpense(_ tripExpense: [APIService.TripsDataAttributes.TripExpense]) -> String {
        
        return tripExpense.filter( { $0.status == 0 } ).map( { $0.amount?.toDouble() ?? 0 } ).reduce(0, +).round()
    }
    
    func rejectedExpense(_ tripExpense: [APIService.TripsDataAttributes.TripExpense]) -> String {
        
        return tripExpense.filter( { $0.status == 3 } ).map( { $0.amount?.toDouble() ?? 0 } ).reduce(0, +).round()
    }
    
    
}
