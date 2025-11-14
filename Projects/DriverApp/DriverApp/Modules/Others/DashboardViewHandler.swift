//
//  DashboardViewHandler.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI

struct DashboardViewHandler: View {
    
    @State var dashboardPath: DashboardRoute
    
    var body: some View {
            
        switch dashboardPath {
        
        case .lrUpload(let id, let lr):
            
            LrUploadView(zoneId: id, lrDetails: lr)
                .navigationTitle("Lorry Receipt (LR)")
            
        case .podUpload(let id, let pod):
            
            PodUploadView(zoneId: id, podDetails: pod)
                .navigationTitle("proof of Delivery (POD)")
            
        case .docUpload(let id, let doc):
            
            DocUploadView(zoneId: id, docDetails: doc)
                .navigationTitle("Documents (Doc)")
            
        case .operationgExpenses(let id, let opExpenses):
            
            OperatingExpensesView(zoneId: id, opExpenses: opExpenses)
                .navigationTitle("Operating Expenses")
            
        case .zoneInfo(let location, let date, let lrNumber, let loadingCharges, let unloadingCharges, let lrImage, let podImage, let docImage):
            
            ZoneInfoView(location: location, inTime: date, lrNumber: lrNumber, loadingCharges: loadingCharges, unloadingCharges: unloadingCharges, lrImage: lrImage, podImage: podImage, docImage: docImage)
                        
        }
        
    }
    
}

#Preview {
//    DashboardViewHandler()
}
