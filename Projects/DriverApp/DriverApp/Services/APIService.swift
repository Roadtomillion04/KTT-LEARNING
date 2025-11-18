//
//  APIService.swift
//  DriverApp
//
//  Created by Nirmal kumar on 18/09/25.
//

// session-Token is used in some Get Requests to get data for that logged in Driver, where no id is used in query params

// re init() the structs before jsonData, otherwise duplicate results happen

// attendance check in and Leave Request gated behind geozone location?

import Foundation
import SwiftyJSON

@MainActor
class APIService: ObservableObject {
    
    private var applicationId = Bundle.main.infoDictionary?["APPLICATION_ID"] as? String ?? ""
    private var restApiKey = Bundle.main.infoDictionary?["REST_API_KEY"] as? String ?? ""
    private var sessionToken = Bundle.main.infoDictionary?["SESSION_TOKEN"] as? String ?? ""
    private var cdnUrl = Bundle.main.infoDictionary?["DEV_CDN_URL"] as? String ?? ""
    private var driverId = Bundle.main.infoDictionary?["DRIVER_ID"] as? String ?? ""
    
    private var apiUrl = Bundle.main.infoDictionary?["DEV_API_URL"] as? String ?? ""
    
    var internetConnectivity: Bool = false
    var headers: [String: String] = [:]
    
    init() {
        
        applicationId = applicationId.replacingOccurrences(of: "\"", with: "")
        restApiKey = restApiKey.replacingOccurrences(of: "\"", with: "")
        sessionToken = sessionToken.replacingOccurrences(of: "\"", with: "")
        cdnUrl = "https://" + cdnUrl.replacingOccurrences(of: "\"", with: "")
        apiUrl = "https://" + apiUrl.replacingOccurrences(of: "\"", with: "")
        
        // for some reason, prefixing https:// in secrets.xcconfig result unexpected behaviour
        
        driverId = driverId.replacingOccurrences(of: "\"", with: "")
        
        headers = [
            "Content-Type": "application/json",
            "X-AT-REST-API-Key": restApiKey,
            "X-AT-Application-Id": applicationId,
            "X-AT-SessionToken": sessionToken
        ]

    }
    
    
    struct LoginSeriveAttributes {
        var driverId: String?
        var sessionToken: String?
    }
    
    @Published var loginSeriveAttributes: LoginSeriveAttributes = .init()
    
    struct ProfileSummaryAttributes {
        var success: Bool?
        var totalTrips: Int?
        var onTimeTrips: Int?
        var totalKms: Int?
        var daysInMonth: Int?
        var presentInMonth: Int?
    }
    
    @Published var profileSummaryAttributes: ProfileSummaryAttributes = .init()
    
    
    struct DriverStatusAttributes {

        var success: Bool?
        var driver: Driver = .init()
        var driverAttendance: EmptyDict = .init()
        var trip: TripZoneData = .init()
        var nextTrip: EmptyDict = .init()
        var error: String?
        
        struct Driver {
            var id, type: Int?
            var name, employeeNo, phone1: String?
            var status: Int?
            var phone2, phone3: String?
            var email: [Email] = []
            var dlno, dlexp: String?
            var dlPhotoURL: DLPhotoURLClass = .init()
            var dlType, dlIssuedBy, desc, photoURL: String?
            var idProofURL: DLPhotoURLClass = .init()
            var idProofType: String?
            var group: String?
            var lastLocation: LastLocation = .init()
            var heir: Heir = .init()
            var spouse: Spouse = .init()
            var ref: Ref = .init()
            var addressList: [AddressList] = []
            var aadhaarNo: String?
            var bankDetails: BankDetails = .init()
            var dateOfBirth, dateOfJoining: String?
            var driverStatistics: EmptyDict = .init()
            var priorExperience: PriorExperience = .init()
            var gender: String?
            var languages: EmptyDict = .init()
            var maritalStatus: String?
            var manager: Manager = .init()
            var salary: String?
            var shiftTiming: EmptyDict = .init()
            var bloodGroup: String?
            var tripBalance: String?
            var activeStatus, verify: Bool?
            var accountIDS: [String] = []
            var iButtonID: String?
            var lastTrip: EmptyDict = .init()
            var leaveAvailability: EmptyDict = .init()
            var blacklist: Bool?
            var config: EmptyDict = .init()
            var covid19: Covid19 = .init()
            var auditLog: [String] = []
            var details: Details = .init()
            var cards: EmptyDict = .init()
            var createdAt, updatedAt: String?
            var accountID: Int?
            var assetID: String?
            var driverGroupID: String?
            var groupID, userIDCreatedBy: Int?
            var userIDVerifiedBy: String?
            var asset: Asset = .init()
            var account: Account = .init()
        }
        
        struct Asset {
            var lplate: String?
            var tripId: String?
            var availability: EmptyDict = .init()
            var tripStatus: Int?
            var odo: String?
            var details: AssetDetails = .init()
        }
        
        struct AssetDetails {
            var emissionNorms: String?
        }

        struct Account {
            var id: Int?
            var driverConfig: DriverConfig = .init()
            var tripConfig: TripConfig = .init()
        }

        struct DriverConfig {
            var trip: Trip = .init()
            var driverCheckIn, attendanceCheckin: Bool?
        }

        struct Trip {
            var uom: [String] = []
            var stop, close: Bool?
            var create: Create = .init()
            var maxImages: MaxImages = .init()
            var unloading: Unloading = .init()
        }

        struct Create {
            var zone, driver: Bool?
            var images: [Image] = []
            var vehicle: Bool?
            var routeTypes: [String] = []
        }

        struct Image {
            var key: String?
            var must: Bool?
            var name: String?
        }

        struct MaxImages {
            var lr: Int?
            var pod: Int?
            var docs: Int?
        }
        
        struct Unloading {
            var type: String?
            var zone: Bool?
            var images: [Image] = []
        }

        struct TripConfig {
            var autoTrip: Bool?
            var tripEntry: TripEntry = .init()
            var driverCheckIn: Bool?
            var advanceBreakup: [String] = []
            var simpleSettlement: Bool?
        }

        struct TripEntry {
            var branch: Branch = .init()
            var customer: Branch = .init()
            var tripFreightCharge: Branch = .init()
        }

        struct Branch {
            var show: Bool?
        }

        struct AddressList {
            var type, address: String?
        }

        struct BankDetails {
            var name, accNo, account, ifsc: String?
            var bank, location, bankProof: String?
        }

        struct EmptyDict {}

        struct Covid19 {
            var firstDose, secondDose, vaccineName, covid19CERTURL: String?
        }

        struct Details {
            var city, type, pinCode: String?
            var createdBy: CreatedBy = .init()
            var fatherName, dlCurrentIssueDate, dlInitialIssueDate: String?
        }

        struct CreatedBy {
            var id: Int?
            var date, name: String?
        }

        struct DLPhotoURLClass {
            var front, back: String?
        }

        struct Email {
            var email1, email2: String?
        }

        struct Heir {
            var heirName, heirPhone: String?
        }

        struct LastLocation {
            var timestamp: Date?
            var locName, lat, lon, loginLat: String?
            var loginLon: String?
            var loginTime: Date?
            var device: String?
        }

        struct Manager {
            var name, email, phone: String?
        }

        struct PriorExperience {
            var totalYears, companyName, companyPhone, description: String?
        }

        struct Ref {
            var refName, refPhone: String?
        }

        struct Spouse {
            var spouseName, spousePhone: String?
        }
        
        struct TripZoneData {
            var id: Int?
            var refNo: String?
            var status: Int?
            var statusCustom, startL, endL: String?
            var estDuration, estKM: Int?
            var weights: EmptyDict = .init()
            var photos: Photos = .init()
            var actKM, routeID: Int?
            var loadIn, loadOut, unloadIn, unloadOut: String?
            var createdAt: String?
            var routeData: RouteData = .init()
            var assetID: Int?
            var loadID: Int?
            var share: Share = .init()
            var odo, endOdo: String?
            var details: TripDetails = .init()
            var route: Route = .init()
            var tripAdvances: [APIService.TripsDataAttributes.TripAdvance] = []
            var tripExpenses: [APIService.TripsDataAttributes.TripExpense] = []
            var load, tripContract, driverStatus: NSNull?
            var startZone: StartZone = .init()
            var endZone: EndZone = .init()
            var allZones: [RouteAllZone] = []
            var addStop: Bool?
            var lplate: String?
            var assetOdo: Int?
        }
        
        struct RouteAllZone {
            var id: String?
            var zoneCode: String?
            var name, city: String?
            var tat: String?
            var halt: Int?
            var estKM: String?
            var schDay: Int?
            var schIn, schOut: String?
            var geojson: Geojson = .init()
            var ztype: Int?
            var center: [String] = []
            var schedules: [Any] = []
        }

        
        struct DocumentFlags {
            var pod, lr, docs, floor, headLoadCharges, loadingCharges, unloadingCharges: Bool?
        }
        
        struct OpDetails {
            var loadingCharge, unloadingCharge: String?
            var headChargeAvailable: String?
        }
        
        struct Geojson {
            var point: [Point] = []
            var radius: String?
        }

        struct Point {
            var lat, lng: Double?
        }

        struct TripDetails {
            var startSoc: String?
            var goodsType: String?
        }

        struct EndZone {
            var id, zoneCode, name: String?
            var city: String?
            var tat, halt: String?
            var estKM, schDay: Int?
            var schIn, schOut: String?
            var geojson: Geojson = .init()
            var ztype: Int?
            var center: [String] = []
            var schedules: [Any] = []
        }

        struct Photos {
            var dl, rc, pan, pod: String?
            var permit: String?
            var challan: [Any] = []
            var chassis, invoice, ewaybill, checklist: String?
            var insurance, driverPhoto, fullVehicle, penaltyBill: String?
            var emptyVehicle, lorryReceipt: String?
        }

        struct Route {
            var name, group: String?
            var estDuration, estKM: Int?
            var allZones: [RouteAllZone] = []
        }

        struct RouteData {
            var route: RouteClass = .init()
            var routeAdv: EmptyDict = .init()
        }

    
        struct RouteClass {
            var id: Int?
            var name: String?
            var estDuration, estKM: Int?
            var allZones: [RouteAllZoneClass] = []
            var actKM: Int?
        }
        
        struct RouteAllZoneClass {
            var id: String?
            var zoneCode: String?
            var name: String?
            var city: String?
            var tat, halt: String?
            var estKM: String?
            var schDay: Int?
            var schIn: String?
            var schOut: String?
            var geojson: Geojson = .init()
            var ztype: Int?
            var center: [String] = []
            var schedules: [Any] = []
            var eta, etd, loadType: String?
            var documentFlags: DocumentFlags = .init()
            var opDetails: OpDetails = .init()
            var inTime: String?
            var details: AllZoneDetails = .init()
            var legKM, zoneSeq: Int?
            var outTime: String?
            var estTatMins: Int?
            var actualTatMins: NSNull?
        }

        
        struct Share {
            var allZones: [ShareAllZone] = []
        }

        struct ShareAllZone {
            var id, tat: Int?
            var city, name: String?
            var inOdo, inSoc, ztype: Int?
            var inTime: String?
            var outOdo: Double?
            var outSoc: Int?
            var details: AllZoneDetails = .init()
            var geojson: Geojson = .init()
            var outTime: String?
            var actDuration: Int?
            
            var lrUpload: Int? // which is url count to display on DashboardView
            var podUpload: Int?
            var docUpload: Int?

        }
        
        struct AllZoneDetails {
            var lr: ShareImages = .init()
            var pod: ShareImages = .init()
            var doc: ShareImages = .init()
        }
        
        struct ShareImages: Hashable {
            var images: [ImageShare] = []
            var number: String?
            var loadingCharge: String?
            var headChargeAvailable: String?
            
        }
        
        struct ImageShare: Hashable {
            var url, notes, type, number: String?
            var driver: ShareDriverData = .init()
        }
        
        struct ShareDriverData: Hashable {
            var createdBy: DateOfCreation = .init()
        }
        
        struct DateOfCreation: Hashable {
            var id: Int?
            var date: String?
            var name: String?
        }
        
        struct StartZone {
            var id, zoneCode, name: String?
            var city: String?
            var tat, halt, estKM: String?
            var schDay: Int?
            var schIn: String?
            var schOut: String?
            var geojson: Geojson = .init()
            var ztype: Int?
            var center: [String] = []
            var schedules: [Any?] = []
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }
        
    }

    @Published var driverStatusAttributes: DriverStatusAttributes = .init()
    
    struct DeliveryCancellationReasons {
        var success: Bool?
        var results: [String] = []
        
    }
    
    @Published var deliveryCancellationAttributes: DeliveryCancellationReasons = .init()
    
    struct LeaveReasonAttributes {
        var success: Bool?
        var reasons: [Reasons] = []
        
        struct Reasons: Hashable { // for iteration in ForEach
            var id: String?
            var text: String?
        }
    }
    
    @Published var leaveReasonAttributes: LeaveReasonAttributes = .init()
    
    struct DriverDocumentsAttributes {
        var success: Bool?
        var result: Result = .init()
        
        struct Result {
            var id, type: Int?
            var name: String?
            var group: String?
            var employeeNo, phone1: String?
            var phone2: String?
            var dlno: String?
            var dlPhotoURL: DLPhotoURL = .init()
            var photoURL: String?
            var idProofURL: DLPhotoURL = .init()
            var lplate: String?
            var assetDocs: [AssetDoc] = []
        }
        
        struct AssetDoc {
            var id: Int?
            var name: String?
            var doc: DLPhotoURL = .init()
        }
        
        struct DLPhotoURL {
            var front, back: String?
            var docType: String?
        }
    }
    
    @Published var driverDocumentsAttributes: DriverDocumentsAttributes = .init()
    
    struct VehicleAvailableListAttributes {
        var success: Bool?
        var results: [Results] = []
        
        struct Results: Hashable {
            var id: Int?
            var lplate: String?
        }
    }
    
    @Published var vehicleAvailableListAttributes: VehicleAvailableListAttributes = .init()
    
    struct GeofenceListAttributes {
        var success: Bool?
        var results: [Results] = []
        
        struct Results: Hashable {
            var id: String?
            var name: String?
            var distMeter: String?
        }
    }
    
    @Published var geoFenceListAttributes: GeofenceListAttributes = .init()
    
    struct VehicleLastTripZoneAttributes {
        var success: Bool?
        var result: [String: String] = [:]
        
    }
    
    @Published var vehicleLastTripZoneAttributes: VehicleLastTripZoneAttributes = .init()
    
    struct TripsDataAttributes {
        var success: Bool?
        var results: [Results] = []
        var message: String?
        
        var totalAdvances: Double?
        var totalExpenses: Double?
        
        struct Results: Hashable {
            var id: Int?
            var startL, endL: String?
            var routeID, estDuration: Int?
            var loadIn, loadOut: String?
            var unloadIn, unloadOut: String?
            var actKM: Int?
            var estKM: Int?
            var refNo: String?
            var assetID, status: Int?
            var statusCustom: String?
            var statusAccounts: Int?
            var odo: String?
            var endOdo: String?
            var tripAdvances: [TripAdvance] = []
            var tripExpenses: [TripExpense] = []
            var route: String?
            var vehicle: String?
        }
        
        struct TripAdvance: Hashable {
            var id, advLevel: Int?
            var totalAmount: String?
            var breakup: Breakup = .init()
            var extraAmount: ExtraAmount = .init()
            var paidDate, voucherNo: String?
            var status: Int?
            var paymentInfo: PaymentInfo = .init()
            var note, createdAt, updatedAt: String?
            var assetID: Int?
            var bankAccountID: Int?
            var tripID, userIDCreatedBy: Int?
            var userIDUpdatedBy, userIDProcessedBy: String?
        }
        
        struct Breakup: Hashable {
            var fuelLiters, fuel, toll, atm: Int?
            var routeAdv: String?
            var requestedAdvance, cash, vehicleTripBalance, driverTripBalance: Int?
            var note: String?
            var geozoneInfo: GeozoneInfo = .init()
        }
        
        struct GeozoneInfo: Hashable {
            var category: String?
        }
        
        struct ExtraAmount: Hashable {
            
        }
        
        struct PaymentInfo: Hashable {
            var voucherNo: String?
            var paidTo: [String] = []
            var cardNumber: [String] = []
        }
        
        struct TripExpense: Hashable {
            var id: Int?
            var date, type: String?
            var location: Location = .init()
            var details: Details = .init()
            var amount, paymentMode: String?
            var billToCust, paidDate: String?
            var voucherNo, comments: String?
            var images: [UIImage] = []
            var verified: Bool?
            var status: Int?
            var isValidExpense: Bool?
            var createdAt, updatedAt: String?
            var driverIDCreatedBy: String?
            var tripID, assetID: Int?
            var userIDExpense: String?
            var userIDCreatedBy: String?
            var userIDUpdatedBy: String?
        }
        
        struct Details: Hashable {
            var billNumber: String?
            var tempImageNames: [String] = []
            var costPerLiter: String?
            var liters: String?
            var odo: String?
        }
        
        struct Location: Hashable {
            var lat, lon, name: String?
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }
        
    }
    
    @Published var tripsDataAttributes: TripsDataAttributes = .init()
        
    struct ExpenseTypes: Hashable {
        var success: Bool?
        var results: [Results] = []
        
        struct Results: Hashable {
            var type: String?
            var show: Bool?
            var text: String?
            var comments: Bool?
            var image: Bool?
            var cashCard: Bool?
            var mobile: Bool?
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }
    }
    
    @Published var expenseTypesAttributes: ExpenseTypes = .init()
    
    // for editing data in addTripExpense
    struct TripExpense {
        var success: Bool?
        var result: Result = .init()
        
        struct Result: Hashable {
            var id: Int?
            var date, type: String?
            var location: Location = .init()
            var details: Details = .init()
            var amount, paymentMode: String?
            var billToCust, paidDate: String?
            var voucherNo, comments: String?
            var images: [UIImage] = []
            var verified: Bool?
            var status: Int?
            var isValidExpense: Bool?
            var createdAt, updatedAt: String?
            var driverIDCreatedBy: String?
            var tripID, assetID: Int?
            var userIDExpense: String?
            var userIDCreatedBy: String?
            var userIDUpdatedBy: String?
        }
        
        struct Details: Hashable {
            var billNumber: String?
            var tempImageNames: [String] = []
            var costPerLiter: String?
            var liters: String?
            var odo: String?
        }
        
        struct Location: Hashable {
            var lat, lon, name: String?
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }

    }
    
    @Published var tripExpenseAttributes: TripExpense = .init()
    
    struct DriverCheckIn: Hashable {
        var success: Bool?
        var results: [Results] = []
        
        struct Results: Hashable {
            var id, date: String?
            var images: [String]?
            var details: Details = .init()
            var geozone: GeoZone = .init()
        }
        
        struct Details: Hashable {
            var time: String?
            var assetID: Int?
            var offline: Bool?
            var location: Location = .init()
            var geoZoneID: String?
            var isNearVehicle, isInsideGeozone: Bool?
            
        }
        
        struct Location: Hashable {
            var lat, lon: Double?
            var address: String?
        }
        
        struct GeoZone: Hashable {
            var id, name, city: String?
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }

    }
    
    @Published var driverCheckInAttributes: DriverCheckIn = .init()
    
    struct PoiZoneList {
        var success: Bool?
        var result: [Result] = []
        
        struct Result {
            var id: String?
            var ztype: Int?
            var type, name: String?
            var zoneCode: String?
            var geojson: Geojson = .init()
            var scale: Int?
            var fullName, address, city, phone: String?
        }

        struct Geojson {
            var point: [Point] = []
        }

        struct Point {
            var lat, lng: Double?
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }
    }
    
    @Published var poiListAttributes: PoiZoneList = .init()
    
    struct TollList {
        var success: Bool?
        var result: [Results] = []
        
        struct Results {
            var id: Int?
            var type: String?
            var data: DataClass?
            var active: Bool?
            var createdAt, updatedAt: String?
        }
        
        struct DataClass {
            var tollName: String?
            var latitude, longitude: Double?
            var plazaCode, type, city, state: String?
            var carRateSingle, carRateDouble, lcvRateSingle, lcvRateDouble: Int?
            var multiAxleRateSingle, multiAxleRateDouble, hcvRateSingle, hcvRateDouble: Int?
            var sixAxleRateSingle, sixAxleRateDouble, sevenAxleRateSingle, sevenAxleRateDouble: Int?
            var address: String?
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }
    }
    
    @Published var tollListAttributes: TollList = .init()
    
    struct FuelList {
        var result: [Results] = []
        
        struct Results {
            var roname: String?
            var rocat: String?
            var lo: String?
            var sp: Double?
            var cn: String?
            var cp: String?
            var lat: Double?
            var lng: Double?
            var lupdate: String?
            var co: Int?
        }
        
        mutating func reset() {
            self = .init() // it overwrites the struct instance
        }
    }
    
    @Published var fuelListAttributes: FuelList = .init()
}

// LoginView
extension APIService {
    
    func sendOtp(mobileNumber: String) async throws -> Bool {

        let jsonBody = [
            "hashKey": "2LY3ik+CoEl"
        ]
        let data = try! JSONSerialization.data(withJSONObject: jsonBody, options: [])

        let url = URL(string: apiUrl + "/drivers/login?phone=\(mobileNumber)")!
        
        let headers = [
            "Content-Type": "application/json",
            "X-AT-REST-API-Key": restApiKey,
            "X-AT-Application-Id": applicationId
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data

        
        // check internet before request
//        await ConnectivityService.sharedInstance.checkConnectivity { success in
//            
//            self.internetConnectivity = success
//            return
//
//        }
        
        let (resData, response) = try await URLSession.shared.data(for: request)
            
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 203 else {
                 throw CustomErrorDescription.badResponse
             }
        
        let jsonData = try? JSON(data: resData)

        return jsonData?["success"].bool ?? false
        
    }
    
    
    func verifyOtp(mobileNumber: String, otp: String) async throws -> Bool {

        let jsonBody = [
            "otp": otp
        ]
        let data = try! JSONSerialization.data(withJSONObject: jsonBody, options: [])

        let url = URL(string: apiUrl + "/drivers/login?phone=\(mobileNumber)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data

        
        let (resData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 403 else {
                throw CustomErrorDescription.badResponse
            }
                
        let jsonData = try? JSON(data: resData)
                
        loginSeriveAttributes.driverId = jsonData?["employeeNo"].string
        
        loginSeriveAttributes.sessionToken = jsonData?["sessionToken"].string
        
        return jsonData?["success"].bool ?? false
        
    }
    
}


// DriverStatus
extension APIService {
    
    func getDriverStatus(cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) async throws {
        
        let url = URL(string: apiUrl + "/drivers/getDriverStatus/\(driverId)")!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.cachePolicy = cachePolicy
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
                }
                    
        // swiftyJSON works like js, JSONDecoder() struggles/gets very long on big json data
        
        let jsonData = try? JSON(data: data)
        
        print(jsonData?["error"] ?? "")
        
        driverStatusAttributes.reset()
        
        driverStatusAttributes.success = jsonData?["success"].bool
        
        driverStatusAttributes.error = jsonData?["error"].string
        
        driverStatusAttributes.driver.name = jsonData?["driver"]["name"].string
        
        driverStatusAttributes.driver.phone1 = jsonData?["driver"]["phone1"].string
        
        driverStatusAttributes.driver.dateOfBirth = jsonData?["driver"]["dateOfBirth"].string
        
        driverStatusAttributes.driver.dlno = jsonData?["driver"]["dlno"].string
        
        driverStatusAttributes.driver.dlexp = jsonData?["driver"]["dlexp"].string
        
        driverStatusAttributes.driver.id = jsonData?["driver"]["id"].int
   
        driverStatusAttributes.driver.photoURL = cdnUrl + (jsonData?["driver"]["photoURL"].string ?? "")
        
        driverStatusAttributes.driver.asset.tripStatus = jsonData?["driver"]["Asset"]["tripStatus"].int
        
        driverStatusAttributes.driver.account.driverConfig.trip.maxImages = DriverStatusAttributes.MaxImages(
            lr: jsonData?["driver"]["Account"]["driverConfig"]["trip"]["maxImages"]["lr"].int,
            pod: jsonData?["driver"]["Account"]["driverConfig"]["trip"]["maxImages"]["pod"].int,
            docs: jsonData?["driver"]["Account"]["driverConfig"]["trip"]["maxImages"]["docs"].int
        )
        
        // Trip data
        driverStatusAttributes.trip.id = jsonData?["Trip"]["id"].int
        driverStatusAttributes.trip.statusCustom = jsonData?["Trip"]["statusCustom"].string
        driverStatusAttributes.trip.actKM = jsonData?["Trip"]["actKM"].int
        driverStatusAttributes.trip.odo = jsonData?["Trip"]["odo"].string
        
        
        driverStatusAttributes.trip.routeData.route.estKM =  jsonData?["Trip"]["routeData"]["route"]["estKM"].int
        
        driverStatusAttributes.trip.routeData.route.estDuration = jsonData?["Trip"]["routeData"]["route"]["estDuration"].int
        
        driverStatusAttributes.trip.status = jsonData?["Trip"]["status"].int
        
        driverStatusAttributes.trip.createdAt = jsonData?["Trip"]["createdAt"].string
        
        
        // since routeData itself contains uploaded Image details, no need for share 
        var zoneIdx = 0
        
        for data in jsonData?["Trip"]["routeData"]["route"]["allZones"] ?? [] {
            driverStatusAttributes.trip.routeData.route.allZones.append(DriverStatusAttributes.RouteAllZoneClass(
                id: data.1["id"].string, // each zone(location) has it's own id
                name: data.1["name"].string,
                city: data.1["city"].string,
                loadType: data.1["loadType"].string,
                documentFlags: DriverStatusAttributes.DocumentFlags(
                    pod: data.1["documentFlags"]["pod"].bool,
                    lr: data.1["documentFlags"]["lr"].bool,
                    docs: data.1["documentFlags"]["docs"].bool,
                    floor: data.1["documentFlags"]["floor"].bool,
                    headLoadCharges: data.1["documentFlags"]["headLoadCharges"].bool,
                    loadingCharges: data.1["documentFlags"]["loadingCharges"].bool,
                    unloadingCharges: data.1["documentFlags"]["unloadingCharges"].bool
                ),
                opDetails: DriverStatusAttributes.OpDetails(
                    loadingCharge: data.1["details"]["loadingCharge"].string,
                    unloadingCharge: data.1["details"]["unloadingCharge"].string,
                    headChargeAvailable: data.1["details"]["headChargeAvailable"].string
                ),
                inTime: data.1["inTime"].string,
                
                zoneSeq: data.1["zoneSeq"].int,
                
                outTime: data.1["outTime"].string
                
            ))
            
            // geojson, lat and lon for maps
            for points in data.1["geojson"]["point"] {
                
                driverStatusAttributes.trip.routeData.route.allZones[zoneIdx].geojson.point.append(DriverStatusAttributes.Point(lat: points.1["lat"].double, lng: points.1["lng"].double))
            }
            
            
            // lr
            for lrImage in data.1["details"]["lr"]["images"] {
                
                driverStatusAttributes.trip.routeData.route.allZones[zoneIdx].details.lr.images.append(DriverStatusAttributes.ImageShare(
                    
                    url: cdnUrl + (lrImage.1["url"].string ?? ""),
                    notes: lrImage.1["notes"].string,
                    
                    driver: DriverStatusAttributes.ShareDriverData(createdBy: DriverStatusAttributes.DateOfCreation(
                        
                        id: lrImage.1["driver"]["createdBy"]["id"].int,
                        date: lrImage.1["driver"]["createdBy"]["date"].string,
                        name: lrImage.1["driver"]["createdBy"]["name"].string
                        
                    ))))
                
                driverStatusAttributes.trip.routeData.route.allZones[zoneIdx].details.lr.number = data.1["details"]["lr"]["number"].string
                
            }
            
            
            // pod
            for podImage in data.1["details"]["pod"]["images"] {
                
                driverStatusAttributes.trip.routeData.route.allZones[zoneIdx].details.pod.images.append(DriverStatusAttributes.ImageShare(
                    
                    url: cdnUrl + (podImage.1["url"].string ?? ""),
                    notes: podImage.1["notes"].string,
                    
                    driver: DriverStatusAttributes.ShareDriverData(createdBy: DriverStatusAttributes.DateOfCreation(
                        
                        id: podImage.1["driver"]["createdBy"]["id"].int,
                        date: podImage.1["driver"]["createdBy"]["date"].string,
                        name: podImage.1["driver"]["createdBy"]["name"].string
                        
                    ))))
                
                
            }
            
            
            // doc
            for docImage in data.1["details"]["docs"] {
                
                driverStatusAttributes.trip.routeData.route.allZones[zoneIdx].details.doc.images.append(DriverStatusAttributes.ImageShare(
                    
                    url: cdnUrl + (docImage.1["url"].string ?? ""),
                    type: docImage.1["type"].string,
                    number: docImage.1["number"].string,
                    
                    driver: DriverStatusAttributes.ShareDriverData(createdBy: DriverStatusAttributes.DateOfCreation(
                        
                        id: docImage.1["driver"]["createdBy"]["id"].int,
                        date: docImage.1["driver"]["createdBy"]["date"].string,
                        name: docImage.1["driver"]["createdBy"]["name"].string
                        
                        
                    ))))
                
                driverStatusAttributes.trip.routeData.route.allZones[zoneIdx].details.doc.loadingCharge = data.1["details"]["loadingCharge"].string
                
                driverStatusAttributes.trip.routeData.route.allZones[zoneIdx].details.doc.headChargeAvailable = data.1["details"]["headChargeAvailable"].string
                
            }
            
            zoneIdx += 1
            
        }
        
        // Trip Advances
        for advance in jsonData?["Trip"]["TripAdvances"] ?? [] {
            
            driverStatusAttributes.trip.tripAdvances.append(APIService.TripsDataAttributes.TripAdvance(
                id: advance.1["id"].int,
                advLevel: advance.1["advLevel"].int,
                totalAmount: advance.1["totalAmount"].string,
                breakup: APIService.TripsDataAttributes.Breakup(
                    fuelLiters: advance.1["breakup"]["fuelLiters"].int,
                    fuel: advance.1["breakup"]["fuel"].int,
                    toll: advance.1["breakup"]["toll"].int,
                    atm: advance.1["breakup"]["atm"].int,
                    routeAdv: advance.1["breakup"]["routeAdv"].string,
                    requestedAdvance: advance.1["breakup"]["requestedAdvance"].int,
                    cash: advance.1["breakup"]["cash"].int,
                    vehicleTripBalance: advance.1["breakup"]["vehicleTripBalance"].int,
                    driverTripBalance: advance.1["breakup"]["driverTripBalance"].int,
                    note: advance.1["breakup"]["note"].string,
                    geozoneInfo: TripsDataAttributes.GeozoneInfo(category: advance.1["breakup"]["geozoneInfo"]["category"].string)
                ),
                paidDate: advance.1["paidDate"].string,
                voucherNo: advance.1["voucherNo"].string,
                status: advance.1["status"].int,
                paymentInfo: APIService.TripsDataAttributes.PaymentInfo(
                    voucherNo: advance.1["paymentInfo"]["voucherNo"].string,
                    paidTo: advance.1["paymentInfo"]["paidTo"].arrayObject as? [String] ?? [],
                    cardNumber: advance.1["paymentInfo"]["cardNumber"].arrayObject as? [String] ?? []
                ),
                note: advance.1["note"].string,
                createdAt: advance.1["createdAt"].string,
                updatedAt: advance.1["updatedAt"].string,
                assetID: advance.1["AssetId"].int,
                bankAccountID: advance.1["BankAccountId"].int,
                tripID: advance.1["TripId"].int
                
            ))
            
        }
        
        // Trip Expenses
        for expense in jsonData?["Trip"]["TripExpenses"] ?? [] {
            
            driverStatusAttributes.trip.tripExpenses.append(APIService.TripsDataAttributes.TripExpense(
                id: expense.1["id"].int,
                date: expense.1["date"].string,
                type: expense.1["type"].string,
                location: APIService.TripsDataAttributes.Location(
                    lat: expense.1["location"]["lat"].string,
                    lon: expense.1["location"]["lon"].string,
                    name: expense.1["location"]["name"].string
                ),
                details: TripsDataAttributes.Details(
                    billNumber: expense.1["details"]["billNumber"].string,
                    tempImageNames: expense.1["details"]["tempImageNames"].arrayObject as? [String] ?? [],
                    costPerLiter: expense.1["details"]["costPerLiter"].string,
                    liters: expense.1["details"]["liters"].string,
                    odo: expense.1["details"]["odo"].string
                ),
                amount: expense.1["amount"].string,
                paymentMode: expense.1["paymentMode"].string,
                paidDate: expense.1["paidDate"].string,
                comments: expense.1["comments"].string,
                images: expense.1["images"].arrayObject as? [UIImage] ?? [],
                verified: expense.1["verified"].bool,
                status: expense.1["status"].int,
                isValidExpense: expense.1["isValidExpense"].bool,
                createdAt: expense.1["createdAt"].string,
                updatedAt: expense.1["updatedAt"].string,
                driverIDCreatedBy: expense.1["DriverIdCreatedBy"].string,
                tripID: expense.1["TripId"].int,
                assetID: expense.1["AssetId"].int
            ))
            
        }
        
        driverStatusAttributes.trip.addStop = jsonData?["Trip"]["addStop"].bool
        
        driverStatusAttributes.trip.lplate = jsonData?["Trip"]["lplate"].string
    
        driverStatusAttributes.trip.assetOdo = jsonData?["Trip"]["AssetOdo"].int
        
    }
    
    // all three lr, pod and doc use same, also the same api used for deletion of images
    // notes cannot be edited, and also opearting expenses use same api
    func uploadDocuments(docType: DocumentType, zoneId: String) async throws -> Bool {

        let url = URL(string: apiUrl + "/drivers/trip/stop/update/\(driverStatusAttributes.trip.id ?? -1)")!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "PUT"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        func appendFormField(name: String, value: Any) {
            body.append("--\(boundary)\r\n")
            
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        
        switch docType {
        
        case .lr(let lrNumber, let removedFiles, let fileDetails):
            appendFormField(name: "zoneId", value: zoneId)
            
            appendFormField(name: "removedUrls", value: removedFiles.map( { $0.replacingOccurrences(of: cdnUrl, with: "") } ))
            
            var imageDetails: [[String: String]] = []
            
            for detail in fileDetails {
                
                imageDetails.append(["fileName": "\(detail.fileName)", "notes":  "\(detail.notes)"])
                
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: imageDetails)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            appendFormField(name: "imageDetails", value: jsonString)
            
            appendFormField(name: "lrNumber", value: lrNumber)
            
            for detail in fileDetails {
                
                if !detail.fileName.isEmpty {
                    
                    guard let imageData = detail.image.jpegData(compressionQuality: 0.8) else { continue }
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(docType.fileName)\"; filename=\"\(detail.fileName)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    body.append(imageData)
                    body.append("\r\n".data(using: .utf8)!)
                    
                }
                
            }
            
            
        case .pod(let removedFiles, let fileDetails):
            appendFormField(name: "zoneId", value: zoneId)
            
            appendFormField(name: "removedUrls", value: removedFiles.map( { $0.replacingOccurrences(of: cdnUrl, with: "") } ))
            
            var imageDetails: [[String: String]] = []
            
            for detail in fileDetails {
                
                imageDetails.append(["fileName": "\(detail.fileName)", "notes":  "\(detail.notes)"])
                
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: imageDetails)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            appendFormField(name: "imageDetails", value: jsonString)
            
            
            for detail in fileDetails {
                
                if !detail.fileName.isEmpty {
                    
                    // works when setting compressionQuality to 0.8
                    guard let imageData = detail.image.jpegData(compressionQuality: 0.8) else { continue }
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(docType.fileName)\"; filename=\"\(detail.fileName)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    body.append(imageData)
                    body.append("\r\n".data(using: .utf8)!)
                    
                }
                
            }
       
        case .doc(let removedFiles, let documentDetails):
            appendFormField(name: "zoneId", value: zoneId)
            
            appendFormField(name: "removedUrls", value: removedFiles.map( { $0.replacingOccurrences(of: cdnUrl, with: "") } ))
            
            var imageDetails: [[String: String]] = []
            
            for detail in documentDetails {
                
                imageDetails.append(["fileName": "\(detail.fileName)", "number":  "\(detail.number)", "type": "\(detail.type)"])
                
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: imageDetails)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            appendFormField(name: "imageDetails", value: jsonString)
            
            for detail in documentDetails {
                
                if !detail.fileName.isEmpty {
                    
                    // works when setting compressionQuality to 0.8
                    guard let imageData = detail.image.jpegData(compressionQuality: 0.8) else { continue }
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(docType.fileName)\"; filename=\"\(detail.fileName)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    body.append(imageData)
                    body.append("\r\n".data(using: .utf8)!)
                    
                }
                
            }
            
        case .op(let floorNo, let unloadingCharge, let loadingCharge, let headChargeAvailable, let actualWeight):
            
            appendFormField(name: "floorNo", value: floorNo)
            
            appendFormField(name: "unloadingCharge", value: unloadingCharge)
            
            appendFormField(name: "loadingCharge", value: loadingCharge)
            
            appendFormField(name: "headChargeAvailable", value: headChargeAvailable)
            
            appendFormField(name: "zoneId", value: zoneId)
            
            appendFormField(name: "actualWeight", value: actualWeight)
            
        }
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        if let myString = String(data: body, encoding: .utf8) {
            print(myString)
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }

        let jsonResponse = try? JSON(data: data)
        print(jsonResponse?["success"].bool ?? false)
        
        return jsonResponse?["success"].bool ?? false

    }
    
    func getDeliveryCancellationReasons() async throws {
        
        let url = URL(string: apiUrl + "/drivers/trips/delivery/cancellation-reasons")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        deliveryCancellationAttributes.success = jsonData?["success"].bool
        deliveryCancellationAttributes.results = jsonData?["results"].arrayObject as? [String] ?? []
        
    }
    
    func postCancelDeliveryTrip(geoZoneId: String, remarks: String, sequence: Int) async throws {
        
        let jsonBody = [
            "geozoneId": "\(geoZoneId)",
            "remarks": "\(remarks)",
            "sequence": "\(sequence)"
        ]
        
        let jsonRequestData = try! JSONSerialization.data(withJSONObject: jsonBody, options: [])
        
        print(jsonBody)
        
        let url = URL(string: apiUrl + "/drivers/trips/delivery/\(driverStatusAttributes.trip.id ?? -1)/zones/cancel")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonRequestData
        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw CustomErrorDescription.badResponse
//        }
//        
//        let jsonData = try? JSON(data: data)
//        
//        print(jsonData?["message"] ?? "")
        
    }
    
}


// ProfileView
extension APIService {
    
    func getProfileSummary(cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) async throws {

        let url = URL(string: apiUrl + "/drivers/getProfileSummary")!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.cachePolicy = cachePolicy
        
            
        let (data, response) = try await URLSession.shared.data(for: request)
               
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        profileSummaryAttributes.success = jsonData?["success"].bool
        profileSummaryAttributes.totalTrips = jsonData?["DriverProfileSummary"]["totalTrips"].int
        profileSummaryAttributes.onTimeTrips = jsonData?["DriverProfileSummary"]["onTimeTrips"].int
        
        profileSummaryAttributes.totalKms = jsonData?["DriverProfileSummary"]["totalKms"].int
        
        profileSummaryAttributes.daysInMonth = jsonData?["DriverProfileSummary"]["daysInMonth"].int
        profileSummaryAttributes.presentInMonth = jsonData?["DriverProfileSummary"]["presentInMonth"].int
    
            
    }
    
    func updateDrivingLiscense(image: UIImage) {
        
        let url = URL(string: apiUrl + "/drivers/uploadDrivingLicense")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "PUT"
        
        
        
    }
    
}

// LeaveRequestView
extension APIService {
    
    func getDriverLeaveReasons(cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) {

        let url = URL(string: apiUrl + "/driverleave/reasons")!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.cachePolicy = cachePolicy

        Task {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let jsonData = try? JSON(data: data)
            
            leaveReasonAttributes.success = jsonData?["success"].bool
            
            leaveReasonAttributes.reasons.removeAll()
            
            for item in jsonData?["reasons"] ?? [] {
                leaveReasonAttributes.reasons.append(LeaveReasonAttributes.Reasons(id: item.1["id"].string, text: item.1["text"].string))
            }

        }
        
    }
    
    func postDriverLeave() {
        
        let jsonData = [
            "fromDate": "21/09/2025",
            "reason": "Health Issue",
            "toDate": "21/09/2025",
            "remarks": "t dy",
            "status": "Pending"
        ]
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])

        let url = URL(string: apiUrl + "/driverleave")!
  
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data

        Task {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let jsonData = try? JSON(data: data)
            
            
            
        }
        
    }
    
}

// DocumentsView
extension APIService {
    
    func getDriverDocuments(cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) async throws {

        let url = URL(string: apiUrl + "/drivers/documents/\(driverId)")!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.cachePolicy = cachePolicy
        
            
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        driverDocumentsAttributes.success = jsonData?["success"].bool
        
        driverDocumentsAttributes.result.dlPhotoURL.front = cdnUrl + (jsonData?["result"]["dlPhotoURL"]["front"].string ?? "")
        
        driverDocumentsAttributes.result.dlPhotoURL.back = cdnUrl + (jsonData?["result"]["dlPhotoURL"]["back"].string ?? "")
        
        driverDocumentsAttributes.result.idProofURL.front = cdnUrl + (jsonData?["result"]["idProofURL"]["front"].string ?? "")
        
        driverDocumentsAttributes.result.idProofURL.back = cdnUrl + (jsonData?["result"]["idProofURL"]["back"].string ?? "")
        
        driverDocumentsAttributes.result.lplate =  jsonData?["result"]["lplate"].string
        
        // asset docs
        driverDocumentsAttributes.result.assetDocs.removeAll()
        
        for data in jsonData?["result"]["assetDocs"] ?? [] {
            
            driverDocumentsAttributes.result.assetDocs.append(DriverDocumentsAttributes.AssetDoc(
                id: data.1["id"].int,
                name: data.1["name"].string,
                doc: DriverDocumentsAttributes.DLPhotoURL(
                    front: cdnUrl + (data.1["doc"]["front"].string ?? ""),
                    back: cdnUrl + (data.1["doc"]["back"].string ?? "")
            )))
            
        }
        
    }
    
    private func docType(urlString: String) {
        
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        
        
        Task {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            print(response.mimeType)
        }
        
    }
    
}

// CreateTripView - Not for Billione
extension APIService {
    
    func getVehicleAvailableList() {

        let url = URL(string: apiUrl + "/drivers/asset/available/list?appVersion=116")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        Task {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let jsonData = try? JSON(data: data)
            
            vehicleAvailableListAttributes.success = jsonData?["success"].bool
            
            vehicleAvailableListAttributes.results.removeAll()
            
            for data in jsonData?["results"] ?? [] {
                vehicleAvailableListAttributes.results.append(VehicleAvailableListAttributes.Results(id: data.1["id"].int, lplate: data.1["lplate"].string))
            }
            
        }
        
    }
    
    func getVehicleLastTripZone(vehicleId: String) {

        let url = URL(string: apiUrl + "/drivers/asset/lastTrip/zone/\(vehicleId)?appVersion=116")!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers

        Task {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let jsonData = try? JSON(data: data)
            
            vehicleLastTripZoneAttributes.success = jsonData?["success"].bool
            
            vehicleLastTripZoneAttributes.result = jsonData?["result"].dictionaryObject as! [String : String]
            
            
            print(vehicleLastTripZoneAttributes.result)
        }
        
    }
    
    func getGeofenceList() {
        
        let jsonData = [
            "lat": "11.0035921",
            "lon": "76.9702258"
        ]
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])

        let url = URL(string: apiUrl + "/drivers/geofence/list?appVersion=116")!
  

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data

        Task {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let jsonData = try? JSON(data: data)
            
            geoFenceListAttributes.success = jsonData?["success"].bool
            
            geoFenceListAttributes.results.removeAll()
            
            for item in jsonData?["results"] ?? [] {
                geoFenceListAttributes.results.append(GeofenceListAttributes.Results(id: item.1["id"].string, name: item.1["name"].string, distMeter: item.1["distMeter"].string))
            }
            
        }
    }
    
    func getZoneRoutes() {

        let url = URL(string: apiUrl + "/drivers/routes/489054?appVersion=116")!


        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers

        Task {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            
        }
        
    }
    
}


// TripsView
extension APIService {
    
    func getTripsData(startDate: String = Calendar.current.date(byAdding: .day, value: -30, to: Date())?.toString() ?? "", endDate: String = Date().toString(), cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) async throws {
        
        let url = URL(string: apiUrl + "/trips/driver/   \(driverId)?sdate=\(startDate)&edate=\(endDate)")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.cachePolicy = cachePolicy
            
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        tripsDataAttributes.reset()
        
        tripsDataAttributes.success = jsonData?["success"].bool
        
        var index: Int = 0
      
        var totalAdvances: Double = 0
        var totalExpeneses: Double = 0
        
        
        for data in jsonData?["results"] ?? [] {
            
            tripsDataAttributes.results.append(TripsDataAttributes.Results(
                id: data.1["id"].int,
                loadIn: data.1["loadIn"].string,
                loadOut: data.1["loadOut"].string,
                unloadIn: data.1["unloadIn"].string,
                unloadOut: data.1["unloadOut"].string,
                assetID: data.1["AssetId"].int,
                status: data.1["status"].int,
                statusAccounts: data.1["statusAccounts"].int,
                odo: data.1["odo"].string,
                route: data.1["route"].string,
                vehicle: data.1["vehicle"].string
            ))
            
            for advance in data.1["TripAdvances"] {
                
                tripsDataAttributes.results[index].tripAdvances.append(TripsDataAttributes.TripAdvance(
                    
                    id: advance.1["id"].int,
                    advLevel: advance.1["advLevel"].int,
                    totalAmount: advance.1["totalAmount"].string,
                    breakup: TripsDataAttributes.Breakup(
                        fuelLiters: advance.1["breakup"]["fuelLiters"].int,
                        fuel: advance.1["breakup"]["fuel"].int,
                        toll: advance.1["breakup"]["toll"].int,
                        atm: advance.1["breakup"]["atm"].int,
                        routeAdv: advance.1["breakup"]["routeAdv"].string,
                        requestedAdvance: advance.1["breakup"]["requestedAdvance"].int,
                        cash: advance.1["breakup"]["cash"].int,
                        vehicleTripBalance: advance.1["breakup"]["vehicleTripBalance"].int,
                        driverTripBalance: advance.1["breakup"]["driverTripBalance"].int,
                        note: advance.1["breakup"]["note"].string,
                        geozoneInfo: TripsDataAttributes.GeozoneInfo(category: advance.1["breakup"]["geozoneInfo"]["category"].string)
                    ),
                    paidDate: advance.1["paidDate"].string,
                    voucherNo: advance.1["voucherNo"].string,
                    status: advance.1["status"].int,
                    paymentInfo: TripsDataAttributes.PaymentInfo(
                        voucherNo: advance.1["paymentInfo"]["voucherNo"].string,
                        paidTo: advance.1["paymentInfo"]["paidTo"].arrayObject as?  [String] ?? [],
                        cardNumber: advance.1["paymentInfo"]["cardNumber"].arrayObject as? [String] ?? []
                    ),
                    note: advance.1["note"].string,
                    createdAt: advance.1["createdAt"].string,
                    updatedAt: advance.1["updatedAt"].string,
                    assetID: advance.1["AssetId"].int,
                    bankAccountID: advance.1["BankAccountId"].int,
                    tripID: advance.1["TripId"].int
                    
                ))
                
                if advance.1["status"].int == 2 {
                    totalAdvances += Double(advance.1["totalAmount"].string ?? "0") ?? 0
                }
         
            }
        
            var idx = 0
            
            for expense in data.1["TripExpenses"] {
                
                tripsDataAttributes.results[index].tripExpenses.append(TripsDataAttributes.TripExpense(
                    
                    id: expense.1["id"].int,
                    date: expense.1["date"].string,
                    type: expense.1["type"].string,
                    location: TripsDataAttributes.Location(
                        lat: expense.1["location"]["lat"].string,
                        lon: expense.1["location"]["lon"].string,
                        name: expense.1["location"]["name"].string
                    ),
                    details: TripsDataAttributes.Details(
                        billNumber: expense.1["details"]["billNumber"].string,
                        tempImageNames: expense.1["details"]["tempImageNames"].arrayObject as? [String] ?? [],
                        costPerLiter: expense.1["details"]["costPerLiter"].string,
                        liters: expense.1["details"]["liters"].string,
                        odo: expense.1["details"]["odo"].string
                    ),
                    amount: expense.1["amount"].string,
                    paymentMode: expense.1["paymentMode"].string,
                    paidDate: expense.1["paidDate"].string,
                    comments: expense.1["comments"].string,
                    verified: expense.1["verified"].bool,
                    status: expense.1["status"].int,
                    isValidExpense: expense.1["isValidExpense"].bool,
                    createdAt: expense.1["createdAt"].string,
                    updatedAt: expense.1["updatedAt"].string,
                    driverIDCreatedBy: expense.1["DriverIdCreatedBy"].string,
                    tripID: expense.1["TripId"].int,
                    assetID: expense.1["AssetId"].int
                                        
                ))
                
                totalExpeneses += Double(expense.1["amount"].string ?? "0") ?? 0
                
                for imgUrl in expense.1["images"].arrayObject as? [String] ?? [] {
                    
                    try await tripsDataAttributes.results[index].tripExpenses[idx].images.append(downloadImage(urlString: cdnUrl + imgUrl))
                    
                }
                
                idx += 1
                
            }
            
            index += 1
            
        }
        
        
        tripsDataAttributes.message = jsonData?["message"].string
        
        tripsDataAttributes.totalAdvances = totalAdvances
        tripsDataAttributes.totalExpenses = totalExpeneses
    
    }
    
    
    func postTripExpense(assetId: String, tripId: String, paymentMode: String, date: String, type: String, location: String, details: String, amount: String, comments: String, images: [UIImage] = []) async throws {
        
        // form-data is used wherever binary data(image) needs to be sent
        
        let url = URL(string: apiUrl + "/tripexpenses/driver")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
   
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        func appendFormField(name: String, value: Any) {
            body.append("--\(boundary)\r\n")
            
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        appendFormField(name: "AssetId", value: assetId)
        appendFormField(name: "TripId", value: tripId)
        appendFormField(name: "paymentMode", value: paymentMode)
        appendFormField(name: "date", value: date)
        appendFormField(name: "id", value: "0")
        appendFormField(name: "type", value: type)
        appendFormField(name: "location", value: location)
        appendFormField(name: "details", value: details)
        appendFormField(name: "photoTimeStamp", value: Date().toString(format: "dd-MM-yyyy HH:mm:a"))
        appendFormField(name: "amount", value: amount)
        appendFormField(name: "comments", value: comments)

        
        for (index, image) in images.enumerated() { // works when setting compressionQuality to 0.8
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"expenses_\(index + 1).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        
        body.append("--\(boundary)--\r\n")

        if let myString = String(data: body, encoding: .utf8) {
            print(myString)
        }
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        print(jsonData?["success"])
        
    }
    
    
    func putTripExpense(assetId: String, tripId: String, expenseId: String, paymentMode: String, date: String, type: String, location: String, details: String, amount: String, comments: String, images: [UIImage] = []) async throws {
        
        // form-data is used wherever binary data(image) needs to be sent
        
        let url = URL(string: apiUrl + "/tripexpenses/driver/\(expenseId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
   
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func appendFormField(name: String, value: String) {
            body.append("--\(boundary)\r\n")
            
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        appendFormField(name: "AssetId", value: assetId)
        appendFormField(name: "TripId", value: tripId)
        appendFormField(name: "paymentMode", value: paymentMode)
        appendFormField(name: "date", value: date)
        appendFormField(name: "id", value: expenseId)
        appendFormField(name: "type", value: type)
        appendFormField(name: "location", value: location)
        appendFormField(name: "details", value: details)
        appendFormField(name: "photoTimeStamp", value: Date().toString(format: "dd-MM-yyyy HH:mm:a"))
        appendFormField(name: "amount", value: amount)
        appendFormField(name: "comments", value: comments)

        
        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"expenses_\(index + 1).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n")

        if let myString = String(data: body, encoding: .utf8) {
            print(myString)
        }
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        print(jsonData?["success"])
        
    }
    
    
    func getTripExpenseTypes(cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) async throws {
        
        let url = URL(string: apiUrl + "/tripexpenses/expenseTypes")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.cachePolicy = cachePolicy
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        expenseTypesAttributes.reset()
        
        expenseTypesAttributes.success = jsonData?["success"].bool
        
        for data in jsonData?["results"] ?? [] {
            expenseTypesAttributes.results.append(ExpenseTypes.Results(
                type: data.1["type"].string,
                show: data.1["show"].bool,
                text: data.1["text"].string,
                comments: data.1["comments"].bool,
                image: data.1["image"].bool,
                cashCard: data.1["cashCard"].bool,
                mobile: data.1["mobile"].bool
            ))
        }
        
    }
    
    // individual
    func getTripExpense(_ expenseId: Int) async throws {
        
        let url = URL(string: apiUrl + "/tripexpenses/\(expenseId)")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        let jsonData = try? JSON(data: data)
        
        tripExpenseAttributes.reset()
        
        tripExpenseAttributes.success = jsonData?["success"].bool
        
        tripExpenseAttributes.result.id = jsonData?["TripExpense"]["id"].int
        tripExpenseAttributes.result.date = jsonData?["TripExpense"]["date"].string
        tripExpenseAttributes.result.type = jsonData?["TripExpense"]["type"].string
        tripExpenseAttributes.result.location = TripExpense.Location(
            lat: jsonData?["TripExpense"]["location"]["lat"].string,
            lon: jsonData?["TripExpense"]["location"]["lon"].string,
            name: jsonData?["TripExpense"]["location"]["name"].string
        )
        tripExpenseAttributes.result.details = TripExpense.Details(
            billNumber: jsonData?["TripExpense"]["details"]["billNumber"].string,
            tempImageNames: jsonData?["TripExpense"]["details"]["tempImageNames"].arrayObject as? [String] ?? [],
            costPerLiter: jsonData?["TripExpense"]["details"]["costPerLiter"].string,
            liters: jsonData?["TripExpense"]["details"]["liters"].string,
            odo: jsonData?["TripExpense"]["details"]["odo"].string
        )
        tripExpenseAttributes.result.amount = jsonData?["TripExpense"]["amount"].string
        tripExpenseAttributes.result.paymentMode = jsonData?["TripExpense"]["paymentMode"].string
        tripExpenseAttributes.result.paidDate = jsonData?["TripExpense"]["paidDate"].string
        tripExpenseAttributes.result.comments = jsonData?["TripExpense"]["comments"].string
       
        for imgUrl in jsonData?["TripExpense"]["images"].arrayObject as? [String] ?? [] {
            await tripExpenseAttributes.result.images.append(try downloadImage(urlString: cdnUrl + imgUrl))
        }
        
        tripExpenseAttributes.result.verified = jsonData?["TripExpense"]["verified"].bool
        tripExpenseAttributes.result.status = jsonData?["TripExpense"]["status"].int
        tripExpenseAttributes.result.isValidExpense = jsonData?["TripExpense"]["isValidExpense"].bool
        tripExpenseAttributes.result.createdAt = jsonData?["TripExpense"]["createdAt"].string
        tripExpenseAttributes.result.updatedAt = jsonData?["TripExpense"]["updatedAt"].string
        tripExpenseAttributes.result.driverIDCreatedBy =  jsonData?["TripExpense"]["DriverIdCreatedBy"].string
        tripExpenseAttributes.result.tripID = jsonData?["TripExpense"]["TripId"].int
        tripExpenseAttributes.result.assetID = jsonData?["TripExpense"]["AssetId"].int
        
    }
    
    
    func deleteExpenese(expenseId: Int) async throws {
        
        let url = URL(string: apiUrl + "/tripexpenses/\(expenseId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomErrorDescription.badResponse
        }
        
        
    }
    
}

// LeaveHistoryView
extension APIService {
    
    func getDriverLeaveHistory() {

        let url = URL(string: apiUrl + "/driverleave/history")!
        

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers

        Task {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
        }

    }
    
}

// check in
extension APIService {
    
    func getDriverCheckIn() async throws {
        
        let url = URL(string: apiUrl + "/driverattendances/checkIn")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
    
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomErrorDescription.badResponse
            }
        
        
        let jsonData = try? JSON(data: data)
        
        driverCheckInAttributes.reset()
     
        driverCheckInAttributes.success = jsonData?["success"].bool
        
        for results in jsonData?["results"] ?? [] {
            
            driverCheckInAttributes.results.append(DriverCheckIn.Results(
                id: results.1["id"].string,
                date: results.1["date"].string,
                images: results.1["images"].arrayObject as? [String],
                details: DriverCheckIn.Details(
                    
                    offline: results.1["details"]["offline"].bool,
                    location: DriverCheckIn.Location(
                        lat: results.1["details"]["location"]["lat"].double,
                        lon: results.1["details"]["location"]["lon"].double,
                        address: results.1["details"]["location"]["address"].string
                    ),
                    geoZoneID: results.1["details"]["GeoZoneId"].string
                ),
                geozone: DriverCheckIn.GeoZone(
                    id: results.1["Geozone"]["id"].string,
                    name: results.1["Geozone"]["name"].string,
                    city: results.1["Geozone"]["city"].string
                )
                                
            ))
            
        }
    }
    
    func postDriverAttendances(image: UIImage, lat: Double, lng: Double, address: String) async throws -> Bool {
        
        let url = URL(string: apiUrl + "/driverattendances/checkIn")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        func appendFormField(name: String, value: Any) {
            body.append("--\(boundary)\r\n")
            
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        appendFormField(name: "lat", value: lat)
        appendFormField(name: "lon", value: lng)
        
        let utcFormatter = ISO8601DateFormatter()
        appendFormField(name: "time", value: utcFormatter.string(from: Date()))
        
        appendFormField(name: "DriverId", value: driverId)
        
        appendFormField(name: "address", value: address)
        
        appendFormField(name: "offline", value: false)
        
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return false }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"images\"; filename=\"selfieImg_\(Int(Date.timeIntervalSinceReferenceDate.rounded())).jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

    
        body.append("--\(boundary)--\r\n")

        if let myString = String(data: body, encoding: .utf8) {
            print(myString)
        }
        
        request.httpBody = body
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomErrorDescription.badResponse
            }
        
        
        let jsonData = try? JSON(data: data)
     
        return jsonData?["success"].bool ?? false
        
        
    }
}

// downloading Images
extension APIService {
    
    func downloadImage(urlString: String) async throws -> UIImage {
        
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
    
            
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomErrorDescription.badResponse
            }
        
        return UIImage(data: data)!
        
    }

    
}

// POI view
extension APIService {
    
    func getPoiZones() async throws {
        
        let url = URL(string: apiUrl + "/geozones/list/PoiZones")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomErrorDescription.badResponse
            }
        
        let jsonData = try? JSON(data: data)
        
        poiListAttributes.reset()
        
        poiListAttributes.success = jsonData?["success"].bool
        
        var idx = 0
        
        for data in jsonData?["results"] ?? [] {
            
            poiListAttributes.result.append(PoiZoneList.Result(
                id: data.1["id"].string,
                name: data.1["name"].string,
                
                fullName: data.1["fullName"].string,
                city: data.1["city"].string,
                phone: data.1["phone"].string
            ))
            
            for point in data.1["geojson"]["point"] {
                poiListAttributes.result[idx].geojson.point.append(PoiZoneList.Point(
                    lat: point.1["lat"].double,
                    lng: point.1["lng"].double
                ))
            }
            
            idx += 1
        }
    }
    
    func getTollList() async throws {
        
        let url = URL(string: apiUrl + "/drivers/listToll")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomErrorDescription.badResponse
            }
        
        let jsonData = try? JSON(data: data)
        
        tollListAttributes.reset()
        
        tollListAttributes.success = jsonData?["success"].bool
        
        for data in jsonData?["results"] ?? [] {
            
            tollListAttributes.result.append(TollList.Results(
                id: data.1["id"].int,
                type: data.1["type"].string,
                data: TollList.DataClass(
                    tollName: data.1["data"]["TollName"].string,
                    latitude: data.1["data"]["latitude"].double,
                    longitude: data.1["data"]["longitude"].double,
                    plazaCode: data.1["data"]["plazaCode"].string,
                    type: data.1["data"]["type"].string,
                    city: data.1["data"]["city"].string,
                    state: data.1["data"]["state"].string,
                    carRateSingle: data.1["data"]["carRateSingle"].int,
                    carRateDouble: data.1["data"]["carRateDouble"].int,
                    lcvRateSingle: data.1["data"]["LCVRateSingle"].int,
                    lcvRateDouble: data.1["data"]["LCVRateDouble"].int,
                    multiAxleRateSingle: data.1["data"]["multiAxleRateSingle"].int,
                    multiAxleRateDouble: data.1["data"]["multiAxleRateDouble"].int,
                    hcvRateSingle: data.1["data"]["HCVRateSingle"].int,
                    hcvRateDouble: data.1["data"]["HCVRateDouble"].int,
                    sixAxleRateSingle: data.1["data"]["sixAxleRateSingle"].int,
                    sixAxleRateDouble: data.1["data"]["sizeAxleRateDouble"].int,
                    sevenAxleRateSingle: data.1["data"]["sevenAxleRateSingle"].int,
                    sevenAxleRateDouble: data.1["data"]["sevenAxleRateDouble"].int,
                    address: data.1["data"]["address"].string
                ),
                active: data.1["active"].bool,
                createdAt: data.1["createdAt"].string,
                updatedAt: data.1["updatedAt"].string
            ))
            
        }
        
        
    }
    
    func getFuelList() async throws {
        
        let url = URL(string: "https://kttelematic.com/images/india-fuel-small.json")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomErrorDescription.badResponse
            }
        
        let jsonData = try? JSON(data: data)

        fuelListAttributes.reset()
        
        for data in jsonData?["d"] ?? [] {
            fuelListAttributes.result.append(FuelList.Results(
                roname: data.1["roname"].string,
                rocat: data.1["rocat"].string,
                lo: data.1["lo"].string,
                sp: Double(data.1["sp"].string ?? ""),
                cn: data.1["cn"].string,
                cp: data.1["cp"].string,
                lat: Double(data.1["lat"].string ?? ""),
                lng: Double(data.1["lng"].string ?? ""),
                lupdate: data.1["lupdate"].string,
                co: data.1["co"].int
            ))
        }
        
    }
    
}
