//
//  TripsModel.swift
//  DriverApp
//
//  Created by Nirmal kumar on 21/11/25.
//

import Foundation

extension APIService {
    
    struct TripsDataModel: Hashable, Decodable {
        var success: Bool?
        var results: [Results] = []
        var message: String? // for trips not found
        var error: String?
        
                
        struct Results: Hashable, Decodable {
            var id: Int?
            var loadIn, loadOut: String?
            var unloadIn, unloadOut: String?
            var assetId, status: Int?
            var statusAccounts: Int?
            var odo: String?
            var tripAdvances: [TripAdvance] = []
            var tripExpenses: [TripExpense] = []
            var route: String?
            var vehicle: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case loadIn
                case loadOut
                case unloadIn
                case unloadOut
                case assetId = "AssetId"
                case status
                case statusAccounts
                case odo
                case tripAdvances = "TripAdvances"
                case tripExpenses = "TripExpenses"
                case route
                case vehicle
            }
        }
        
        struct TripAdvance: Hashable, Decodable {
            var id, advLevel: Int?
            var totalAmount: String?
            var breakup: Breakup?
            var paidDate, voucherNo: String?
            var status: Int?
            var paymentInfo: PaymentInfo?
            var note, createdAt, updatedAt: String?
            var assetId: Int?
            var tripId: Int?
            
            enum CodingKeys: String, CodingKey {
                case id
                case advLevel
                case totalAmount
                case breakup
                case paidDate
                case voucherNo
                case status
                case paymentInfo
                case note
                case createdAt
                case updatedAt
                case assetId = "AssetId"
                case tripId = "TripId"
            }
        }
        
        struct Breakup: Hashable, Decodable {
            var fuelLiters, fuel, toll, atm: Int?
            var routeAdv: String?
            var requestedAdvance, cash, vehicleTripBalance, driverTripBalance: Int?
            var note: String?
        }
        
        struct PaymentInfo: Hashable, Decodable {
            var voucherNo: String?
            var paidTo: [String] = []
            var cardNumber: [String] = []
            
            enum CodingKeys: String, CodingKey {
                case voucherNo
                case paidTo
                case cardNumber
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.TripsDataModel.PaymentInfo.CodingKeys> = try decoder.container(keyedBy: APIService.TripsDataModel.PaymentInfo.CodingKeys.self)
                
                self.voucherNo = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.PaymentInfo.CodingKeys.voucherNo)
                
                self.paidTo = try container.decodeIfPresent([String].self, forKey: APIService.TripsDataModel.PaymentInfo.CodingKeys.paidTo) ?? []
                
                self.cardNumber = try container.decodeIfPresent([String].self, forKey: APIService.TripsDataModel.PaymentInfo.CodingKeys.cardNumber) ?? []
            }
        }
        
        struct TripExpense: Hashable, Decodable {
            var id: Int?
            var date, type: String?
            var location: Location?
            var details: Details?
            var amount, paymentMode: String?
            var paidDate: String?
            var comments: String?
            var images: [String] = []
            var verified: Bool?
            var status: Int?
            var isValidExpense: Bool?
            var createdAt, updatedAt: String?
            var tripId, assetId: Int?
            var userIdCreatedBy: Int?
            
            enum CodingKeys: String, CodingKey {
                case id
                case date
                case type
                case location
                case details
                case amount
                case paymentMode
                case paidDate
                case comments
                case images
                case verified
                case status
                case isValidExpense
                case createdAt
                case updatedAt
                case tripId = "TripId"
                case assetId = "AssetId"
                case userIdCreatedBy = "UserIdCreatedBy"
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.TripsDataModel.TripExpense.CodingKeys> = try decoder.container(keyedBy: APIService.TripsDataModel.TripExpense.CodingKeys.self)
                
                self.id = try container.decodeIfPresent(Int.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.id)
                
                self.date = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.date)
                
                self.type = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.type)
                
                self.location = try container.decodeIfPresent(APIService.TripsDataModel.Location.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.location)
                
                self.details = try container.decodeIfPresent(APIService.TripsDataModel.Details.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.details)
                
                self.amount = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.amount)
                
                self.paymentMode = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.paymentMode)
                
                self.paidDate = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.paidDate)
                
                self.comments = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.comments)
                
                let imageUrls = try container.decodeIfPresent([String].self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.images) ?? []
                
                self.images = imageUrls.map( { "https://dev.ktt.io/api/upload/file" + $0 } )
                
                self.verified = try container.decodeIfPresent(Bool.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.verified)
                
                self.status = try container.decodeIfPresent(Int.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.status)
                
                self.isValidExpense = try container.decodeIfPresent(Bool.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.isValidExpense)
                
                self.createdAt = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.createdAt)
                
                self.updatedAt = try container.decodeIfPresent(String.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.updatedAt)
                
                self.tripId = try container.decodeIfPresent(Int.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.tripId)
                
                self.assetId = try container.decodeIfPresent(Int.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.assetId)
                
                self.userIdCreatedBy = try container.decodeIfPresent(Int.self, forKey: APIService.TripsDataModel.TripExpense.CodingKeys.userIdCreatedBy)
                
            }
        }
        
        struct Details: Hashable, Decodable {
            var billNumber: String?
            var costPerLiter: String?
            var liters: String?
            var odo: String?
        }
        
        struct Location: Hashable, Decodable {
            var lat, lon, name: String?
        }
        
    }
    
}
