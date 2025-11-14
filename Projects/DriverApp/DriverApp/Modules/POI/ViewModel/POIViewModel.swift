//
//  POIViewModel.swift
//  DriverApp
//
//  Created by Nirmal kumar on 06/11/25.
//

import Foundation
import MapKit

// selection fuel, toll and poi has to retain value accross views


struct POI: Hashable {
    let name: String
    let lat, lng: Double
    let fullName, city, phone: String
}


struct Fuel: Hashable, Identifiable {
    let id = UUID()
    let name, locationName, contactName, contactPhone: String
    let lat, lng: Double
    let color: Int
}

class POIViewModel: ObservableObject {
    
    @Published var fuelSelected: Bool = false
    @Published var tollSelected: Bool = false
    @Published var poiSelected: Bool = false
    
    @Published var poiList: [POI] = []
    @Published var fuelList: [Fuel] = []
    
    @Published var selectedSnippet: Fuel?
    
    // user location
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var userLocation: CLLocation = .init()
    
    @MainActor
    func onAppear(apiService: APIService, locationManager: LocationManager) {
        parseFuelList(apiService: apiService)
        parsePoiList(apiService: apiService)
        
        userLatitude = locationManager.location?.latitude ?? 0
        userLongitude = locationManager.location?.longitude ?? 0
        
        userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
    }
    
    @MainActor
    func parsePoiList(apiService: APIService) {
        
        for data in apiService.poiListAttributes.result {
            poiList.append(POI(
                name: data.name ?? "",
                lat: data.geojson.point[0].lat ?? 0,
                lng: data.geojson.point[0].lng ?? 0,
                fullName: data.fullName ?? "",
                city: data.city ?? "",
                phone: data.phone ?? ""
            ))
        }
        
    }
    
    @MainActor
    func parseFuelList(apiService: APIService) {
        
        for data in apiService.fuelListAttributes.result {
            fuelList.append(Fuel(
                name: data.roname ?? "",
                locationName: data.lo ?? "",
                contactName: data.cn ?? "",
                contactPhone: data.cp ?? "",
                lat: data.lat ?? 0,
                lng: data.lng ?? 0,
                color: data.co ?? 0
            ))
        }
    }
    
}
