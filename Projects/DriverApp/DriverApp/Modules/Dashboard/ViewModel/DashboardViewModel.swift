//
//  Dashboardvm.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import Foundation
import SwiftUI
import MapKit


struct Trip: Identifiable, Equatable {
    
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return true
    }
    
    
    let id: String
    let locationName: String
    let statusCustom: String // for cancel btn show
    let zoneSeq: Int // index of trip
    let inTime: String
    let outTime: String
    
    // lat and lon for maps open
    let lat: Double
    let lon: Double
    
    let lrShow: Bool
    let podShow: Bool
    let docShow: Bool
    
    // as it's getting bigger, let's wrap it in struct
    struct OpExpenses: Hashable {
        // for op, show if any one is true
        let floor: Bool
        let headLoadingCharges: Bool
        let loadingCharges: Bool
        let unloadingCharges: Bool
        
        // saved op data, weight not received
        let loadingCharge: String
        let unloadingCharge: String
        let headChargeAvailable: String
    }
    
    let opExpenses: OpExpenses
    
    let lr: APIService.DriverStatusAttributes.ShareImages
    let pod: APIService.DriverStatusAttributes.ShareImages
    let docs: APIService.DriverStatusAttributes.ShareImages
    
}



// enum with parameters is efficient than individual parameters in uploadDocuments Api
enum DocumentType: Hashable {
    case lr(lrNumber: String, removedFiles: [String], fileDetails: [FileDetails])
    case pod(removedFiles: [String], fileDetails: [FileDetails])
    case doc(removedFiles: [String], documentDetails: [DocumentDetails])
    case op(floorNo: String = "", unloadingCharge: String = "", loadingCharge: String = "", headChargeAvailable: String, actualWeight: String)
    
    var fileName: String {
        switch self {
        case .lr: return "lr"
        case .pod: return "pod"
        case .doc: return "docs"
        case .op: return ""
        }
    }
    
    struct FileDetails: Hashable {
        let image: UIImage
        let url: String
        let fileName: String
        var notes: String
        var editable: Bool
    }
    
    struct DocumentDetails: Hashable {
        let image: UIImage
        let url: String
        let fileName: String
        var number: String
        var type: String
    }
    
}

final class DashboardViewModel: ObservableObject {

    @Published var trips: [Trip] = []
    
    @Published var collapsed: Bool = true
    @Published var cancelReason: String?
    @Published var showCancelAlert: Bool = false
    
    @Published var selectedTrip: Trip?
    
    @MainActor
    func parseData(apiService: APIService) {
        
        if trips.isEmpty {
            
            for data in apiService.driverStatusAttributes.trip.routeData.route.allZones {
                
                trips.append(
                    Trip(
                        id: data.id ?? "",
                        locationName: data.name ?? "",
                        statusCustom: apiService.driverStatusAttributes.trip.statusCustom ?? "",
                        zoneSeq: data.zoneSeq ?? -1,
                        inTime: data.inTime ?? "",
                        outTime: data.outTime ?? "",
                        
                        // only the first point is enough
                        lat: data.geojson.point[0].lat ?? 0,
                        lon: data.geojson.point[0].lng ?? 0,
                        
                        lrShow: data.documentFlags.lr ?? false,
                        podShow: data.documentFlags.pod ?? false,
                        docShow: data.documentFlags.docs ?? false,
                        
                        opExpenses: Trip.OpExpenses(
                            floor: data.documentFlags.floor ?? false,
                            headLoadingCharges: data.documentFlags.headLoadCharges ?? false,
                            loadingCharges: data.documentFlags.loadingCharges ?? false,
                            unloadingCharges: data.documentFlags.unloadingCharges ?? false,
                            loadingCharge: data.opDetails.loadingCharge ?? "",
                            unloadingCharge: data.opDetails.unloadingCharge ?? "",
                            headChargeAvailable: data.opDetails.headChargeAvailable ?? ""
                        ),
                        
                        lr: data.details.lr,
                        pod: data.details.pod,
                        docs: data.details.doc
                    ))
            }
        }
    }
    
    
    func openMaps(for trip: Trip) {
        
        // 6 decimal places or not
        let latitude: CLLocationDegrees = trip.lat
        let longitude: CLLocationDegrees = trip.lon
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = trip.locationName

        // You can add launch options like directions mode or map span
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    func openMapsTripNavigation() {
        
        var pathNavigation: [MKMapItem] = []
        
        for trip in trips {
            
            let coordinate = CLLocationCoordinate2D(latitude: trip.lat, longitude: trip.lon)
            
            let placeMark = MKPlacemark(coordinate: coordinate)
            
            let mapItem = MKMapItem(placemark: placeMark)
            
            mapItem.name = trip.locationName
            
            pathNavigation.append(mapItem)
            
        }
        
        MKMapItem.openMaps(with: pathNavigation, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        
    }
 
    func totalAdvances(_ tripAdvances: [APIService.TripsDataAttributes.TripAdvance]) -> String {
    
            var total: Double = 0
    
            total = tripAdvances.filter( { $0.status == 2 } ).map( { Double($0.totalAmount ?? "") ?? 0  } ).reduce(0, +)
    
    
            return total.round()
    
        }
    
    func totalExpenses(_ tripExpenses: [APIService.TripsDataAttributes.TripExpense]) -> String {

        var total: Double = 0
        
        total = tripExpenses.map( { Double($0.amount ?? "") ?? 0  } ).reduce(0, +)

        return total.round()

    }
    
}
