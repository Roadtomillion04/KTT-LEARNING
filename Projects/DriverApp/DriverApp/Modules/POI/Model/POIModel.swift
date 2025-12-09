//
//  POIModel.swift
//  DriverApp
//
//  Created by Nirmal kumar on 21/11/25.
//

import Foundation

extension APIService {
    
    struct PoiListModel: Decodable {
        var success: Bool?
        var results: [Result] = []
        var error: String?
        
        struct Result: Decodable {
            var name: String?
            var geojson: Geojson?
            var fullName, city, phone: String?
        }

        struct Geojson: Decodable {
            var point: [Point] = []
        }

        struct Point: Decodable {
            var lat, lng: Double?
        }
    }
    
    struct TollListModel: Decodable {
        var success: Bool?
        var result: [Results] = []
        
        struct Results: Decodable {
            var id: Int?
            var type: String?
            var data: DataClass?
            var active: Bool?
            var createdAt, updatedAt: String?
        }
        
        struct DataClass: Decodable {
            var tollName: String?
            var latitude, longitude: Double?
            var plazaCode, type, city, state: String?
            var carRateSingle, carRateDouble, lcvRateSingle, lcvRateDouble: Int?
            var multiAxleRateSingle, multiAxleRateDouble, hcvRateSingle, hcvRateDouble: Int?
            var sixAxleRateSingle, sixAxleRateDouble, sevenAxleRateSingle, sevenAxleRateDouble: Int?
            var address: String?
        }
    }
    
    struct FuelListModel: Decodable {
        var d: [Results] = []
        var error: String?
        
        struct Results: Decodable {
            var roname: String?
            var lo: String?
            var cn: String?
            var cp: String?
            var lat: Double? // can be casted in containers
            var lng: Double?
            var co: Int?
            
            enum CodingKeys: String, CodingKey {
                case roname
                case lo, cn, cp, lat, lng, co
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.FuelListModel.Results.CodingKeys> = try decoder.container(keyedBy: APIService.FuelListModel.Results.CodingKeys.self)
                self.roname = try container.decodeIfPresent(String.self, forKey: APIService.FuelListModel.Results.CodingKeys.roname)
                
                self.lo = try container.decodeIfPresent(String.self, forKey: APIService.FuelListModel.Results.CodingKeys.lo)
                
                self.cn = try container.decodeIfPresent(String.self, forKey: APIService.FuelListModel.Results.CodingKeys.cn)
                
                self.cp = try container.decodeIfPresent(String.self, forKey: APIService.FuelListModel.Results.CodingKeys.cp)
                
                let lat = try container.decodeIfPresent(String.self, forKey: APIService.FuelListModel.Results.CodingKeys.lat)
                
                let lng = try container.decodeIfPresent(String.self, forKey: APIService.FuelListModel.Results.CodingKeys.lng)
                
                self.lat = Double(lat ?? "")
                self.lng = Double(lng ?? "")
                
                self.co = try container.decodeIfPresent(Int.self, forKey: APIService.FuelListModel.Results.CodingKeys.co)
            }
        }
    }
}

