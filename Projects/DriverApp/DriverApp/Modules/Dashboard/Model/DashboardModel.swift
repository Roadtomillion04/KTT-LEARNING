//
//  DashboardModel.swift
//  DriverApp
//
//  Created by Nirmal kumar on 26/11/25.
//

import Foundation

extension APIService {
    
    struct DriverStatusModel: Decodable {
        
        var success: Bool?
        var driver: Driver?
        var trip: TripClass?
        var error: String?
        
        enum CodingKeys: String, CodingKey {
            case success
            case driver
            case error
            case trip = "Trip"
        }
        
        
        struct Driver: Decodable {
            var id: Int?
            var employeeNo: String?
            var name: String?
            var phone1: String?
            var dlno: String?
            var dlexp: String?
            var dlPhotoURL: DLPhotoURLClass?
            var photoURL: String?
            var dateOfBirth: String?
            var account: Account?
            
            enum CodingKeys: String, CodingKey {
                case dateOfBirth, id, employeeNo, name, phone1, dlno, dlexp, dlPhotoURL, photoURL
                case account = "Account"
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.DriverStatusModel.Driver.CodingKeys> = try decoder.container(keyedBy: APIService.DriverStatusModel.Driver.CodingKeys.self)
                
                self.dateOfBirth = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.dateOfBirth)
                
                self.id = try container.decodeIfPresent(Int.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.id)
                
                self.employeeNo = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.employeeNo)
                
                self.name = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.name)
                
                self.phone1 = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.phone1)
                
                self.dlno = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.dlno)
                
                self.dlexp = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.dlexp)
                
                self.dlPhotoURL = try container.decodeIfPresent(APIService.DriverStatusModel.DLPhotoURLClass.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.dlPhotoURL)
                
                
                let photoURL = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.photoURL)
                
                self.photoURL = "https://dev.ktt.io/api/upload/file" + (photoURL ?? "")
                
                self.account = try container.decodeIfPresent(APIService.DriverStatusModel.Account.self, forKey: APIService.DriverStatusModel.Driver.CodingKeys.account)
            }
        }
        
        
        struct DLPhotoURLClass: Decodable {
            var front: String?
            var back: String?
            
            enum CodingKeys: String, CodingKey {
                case front
                case back
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.DriverStatusModel.DLPhotoURLClass.CodingKeys> = try decoder.container(keyedBy: APIService.DriverStatusModel.DLPhotoURLClass.CodingKeys.self)
                
                let front = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.DLPhotoURLClass.CodingKeys.front)
                
                let back = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.DLPhotoURLClass.CodingKeys.back)
                
                self.front = "https://dev.ktt.io/api/upload/file" + (front ?? "")
                self.back = "https://dev.ktt.io/api/upload/file" + (back ?? "")
            }
        }
        
        struct Account: Decodable {
            var driverConfig: DriverConfig?
        }
        
        struct DriverConfig: Decodable {
            var trip: Trip?
        }
        
        struct Trip: Decodable {
            var maxImages: MaxImages?
        }
        
        struct MaxImages: Decodable {
            var lr: Int?
            var pod: Int?
            var docs: Int?
        }
        
        struct TripClass: Decodable {
            var id: Int?
            var status: Int?
            var statusCustom: String?
            var createdAt: String?
            var odo: String?
            var routeData: RouteData?
            var tripAdvances: [APIService.TripsDataModel.TripAdvance] = []
            var tripExpenses: [APIService.TripsDataModel.TripExpense] = []
            var lplate: String?
            var assetOdo: Int?
            
            enum CodingKeys: String, CodingKey {
                case id
                case status
                case statusCustom
                case createdAt
                case odo
                case routeData
                case tripAdvances = "TripAdvances"
                case tripExpenses = "TripExpenses"
                case lplate
                case assetOdo = "AssetOdo"
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.DriverStatusModel.TripClass.CodingKeys> = try decoder.container(keyedBy: APIService.DriverStatusModel.TripClass.CodingKeys.self)
                
                self.id = try container.decodeIfPresent(Int.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.id)
                
                self.status = try container.decodeIfPresent(Int.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.status)
                
                self.statusCustom = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.statusCustom)
                
                self.createdAt = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.createdAt)
                
                self.odo = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.odo)
                
                self.routeData = try container.decodeIfPresent(APIService.DriverStatusModel.RouteData.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.routeData)
                
                self.tripAdvances = try container.decodeIfPresent([APIService.TripsDataModel.TripAdvance].self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.tripAdvances) ?? []
                
                self.tripExpenses = try container.decodeIfPresent([APIService.TripsDataModel.TripExpense].self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.tripExpenses) ?? []
                
                self.lplate = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.lplate)
                
                self.assetOdo = try container.decodeIfPresent(Int.self, forKey: APIService.DriverStatusModel.TripClass.CodingKeys.assetOdo)
            }
            
        }
        
        struct RouteData: Decodable {
            var route: RouteClass = .init()
        }
        
        struct RouteClass: Decodable {
            var estKM: Double?
            var allZones: [RouteAllZoneClass] = []
        }
        
        struct RouteAllZoneClass: Decodable {
            var id: String? // this comes in either int or string
            var name: String?
            var inTime: String?
            var outTime: String?
            var zoneSeq: Int?
            var geojson: Geojson?
            var documentFlags: DocumentFlags?
            var opDetails: OpDetails?
            var details: AllZoneDetails?
            
            enum CodingKeys: CodingKey {
                case id
                case name
                case inTime
                case outTime
                case zoneSeq
                case geojson
                case documentFlags
                case opDetails
                case details
            }
            
            init(from decoder: any Decoder) throws {
                
                let container: KeyedDecodingContainer<APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys> = try decoder.container(keyedBy: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.self)
                
                if let stringId = try? container.decode(String.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.id) {
                    self.id = stringId
                } else if let intId = try? container.decode(Int.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.id) {
                    self.id = String(intId)
                }
          
                
                self.name = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.name)
                
                self.inTime = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.inTime)
                
                self.outTime = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.outTime)
                
                self.zoneSeq = try container.decodeIfPresent(Int.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.zoneSeq)
                
                self.geojson = try container.decodeIfPresent(APIService.DriverStatusModel.Geojson.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.geojson)
                
                self.documentFlags = try container.decodeIfPresent(APIService.DriverStatusModel.DocumentFlags.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.documentFlags)
                
                self.opDetails = try container.decodeIfPresent(APIService.DriverStatusModel.OpDetails.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.opDetails)
                
                self.details = try container.decodeIfPresent(APIService.DriverStatusModel.AllZoneDetails.self, forKey: APIService.DriverStatusModel.RouteAllZoneClass.CodingKeys.details)
            }
            
        }
        
        struct Geojson: Decodable {
            var point: [Point] = []
        }
        
        struct Point: Decodable {
            var lat: Double?
            var lng: Double?
        }
        
        struct DocumentFlags: Decodable {
            var pod: Bool?
            var lr: Bool?
            var docs: Bool?
            var floor: Bool?
            var headLoadCharges: Bool?
            var loadingCharges: Bool?
            var unloadingCharges: Bool?
        }
        
        struct OpDetails: Decodable {
            var loadingCharge: String?
            var unloadingCharge: String?
            var headChargeAvailable: String?
        }
        
        struct AllZoneDetails: Decodable {
            var loadingCharge: String?
            var headChargeAvailable: String?
            
            var lr: ShareImages?
            var pod: ShareImages?
            var docs: [ImageShare] = []
            
            enum CodingKeys: CodingKey {
                case loadingCharge
                case headChargeAvailable
                case lr
                case pod
                case docs
            }
            
            init(from decoder: any Decoder) throws {
                
                let container: KeyedDecodingContainer<APIService.DriverStatusModel.AllZoneDetails.CodingKeys> = try decoder.container(keyedBy: APIService.DriverStatusModel.AllZoneDetails.CodingKeys.self)
                
                self.loadingCharge = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.AllZoneDetails.CodingKeys.loadingCharge)
                
                self.headChargeAvailable = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.AllZoneDetails.CodingKeys.headChargeAvailable)
                
                self.lr = try container.decodeIfPresent(APIService.DriverStatusModel.ShareImages.self, forKey: APIService.DriverStatusModel.AllZoneDetails.CodingKeys.lr)
                
                self.pod = try container.decodeIfPresent(APIService.DriverStatusModel.ShareImages.self, forKey: APIService.DriverStatusModel.AllZoneDetails.CodingKeys.pod)
                
                
                // okay important note, for arrays, when key is missing in response you get error, so write this check
                self.docs = try container.decodeIfPresent([APIService.DriverStatusModel.ImageShare].self, forKey: APIService.DriverStatusModel.AllZoneDetails.CodingKeys.docs) ?? []
            }
            
            
        }
        
        struct ShareImages: Hashable, Decodable {
            var images: [ImageShare] = []
            var number: String?
        }
                
        struct ImageShare: Hashable, Decodable {
            var url: String?
            var notes: String?
            var type: String?
            var number: String?
            var driver: ShareDriverData?
            
            enum CodingKeys: CodingKey {
                case url
                case notes
                case type
                case number
                case driver
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.DriverStatusModel.ImageShare.CodingKeys> = try decoder.container(keyedBy: APIService.DriverStatusModel.ImageShare.CodingKeys.self)
                
                let urlPath = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.ImageShare.CodingKeys.url)
                
                self.url = "https://dev.ktt.io/api/upload/file" + (urlPath ?? "")
                
                self.notes = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.ImageShare.CodingKeys.notes)
                
                self.type = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.ImageShare.CodingKeys.type)
                
                self.number = try container.decodeIfPresent(String.self, forKey: APIService.DriverStatusModel.ImageShare.CodingKeys.number)
                
                self.driver = try container.decodeIfPresent(ShareDriverData.self, forKey: APIService.DriverStatusModel.ImageShare.CodingKeys.driver)
            }
            
        }
        
        struct ShareDriverData: Hashable, Decodable {
            var createdBy: DateOfCreation?
        }
        
        struct DateOfCreation: Hashable, Decodable {
            var id: Int?
            var name: String?
            var date: String?
        }
        
    }
    
        
    struct DeliveryCancelReasonsModel: Decodable {
        var success: Bool?
        var results: [String] = []
        var error: String?
        
    }
    
}

