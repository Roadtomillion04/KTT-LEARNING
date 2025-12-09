//
//  APIService.swift
//  DriverApp
//
//  Created by Nirmal kumar on 18/09/25.
//

// session-Token is used in some Get Requests to get data for that logged in Driver, where no id is used in query params

import Foundation
import UIKit

@MainActor
class APIService: ObservableObject {
    
    var alertPresenter: CustomAlertPresenter?
    var toastPresenter: ToastPresenter?
    
    private var applicationId = Bundle.main.infoDictionary?["APPLICATION_ID"] as? String ?? ""
    private var restApiKey = Bundle.main.infoDictionary?["REST_API_KEY"] as? String ?? ""
    private var sessionToken = Bundle.main.infoDictionary?["SESSION_TOKEN"] as? String ?? ""
    
    private var driverId = Bundle.main.infoDictionary?["DRIVER_ID"] as? String ?? ""
    
    var apiUrl = Bundle.main.infoDictionary?["DEV_API_URL"] as? String ?? ""
    var cdnUrl = Bundle.main.infoDictionary?["DEV_CDN_URL"] as? String ?? ""
    
    var isConnected: Bool = false
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
            "X-AT-SessionToken": sessionToken,
            "cache-control": "no-cache"
        ]

    }
    
    // one shared model for response success
    struct SuccessModel: Decodable {
        let success: Bool?
        let error: String?
        let message: String?
        
    }
    
    struct ErrorModel: Decodable {
        let error: String?
    }
    
    @Published var loginSeriveAttributes: LoginSeriveAttributes = .init()

    // used in multiple places, so having global variable
    @Published var driverStatusModel: DriverStatusModel = .init()
    
    @Published var tripsDataModel: TripsDataModel = .init()
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
        
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 203 else {
            throw CustomErrorDescription.badResponse()
        }
            
            
            return true
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

    
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 403 else {
            throw CustomErrorDescription.badResponse()
        }
    
        
        return true
        
    }
    
}


// DriverStatus
extension APIService {
    
    func getDriverStatus() async throws {

        do {
            driverStatusModel = try await getApi("/drivers/getDriverStatus/\(driverId)", model: DriverStatusModel.self)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        
    }
    
    
    // all three lr, pod and doc use same, also the same api used for deletion of images
    // notes cannot be edited, and also opearting expenses use same api
    func uploadDocuments(docType: DocumentType, zoneId: String) async throws -> Bool {

        let boundary = UUID().uuidString
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
                    // server file size limit
                    guard let imageData = detail.image.jpegData(compressionQuality: 0.3) else { break }
                    
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
                    
                    // server file size limit
                    guard let imageData = detail.image.jpegData(compressionQuality: 0.3) else { break }
                    
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
                    
                    // server file size limit
                    guard let imageData = detail.image.jpegData(compressionQuality: 0.3) else { break }
                    
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
        
        
        var response: SuccessModel?
        
        do {
            response = try await postApi("/drivers/trip/stop/update/\(driverStatusModel.trip?.id ?? -1)", method: "PUT", body: body, boundary: boundary)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }

        return response?.success ?? false
    }
    
    
    func getDeliveryCancellationReasons() async throws -> DeliveryCancelReasonsModel {
        
        return try await getApi("/drivers/trips/delivery/cancellation-reasons", model: DeliveryCancelReasonsModel.self)
        
    }
    
    func postCancelDeliveryTrip(geoZoneId: String, remarks: String, sequence: Int) async throws {
        
        let jsonBody = [
            "geozoneId": "\(geoZoneId)",
            "remarks": "\(remarks)",
            "sequence": "\(sequence)"
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: jsonBody, options: [])
        
        try await postApi("/drivers/trips/delivery/\(driverStatusModel.trip?.id ?? -1)/zones/cancel", method: "POST", body: body, boundary: "")

    }
    
}


// ProfileView
extension APIService {
    
    func getDriverProfile() async throws -> DriverProfileModel {

        var response: DriverProfileModel = .init()
        
        do {
            response = try await getApi("/drivers/getProfileSummary", model: DriverProfileModel.self)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }

        return response
    }
    
    func updateDriverphoto(image: UIImage, filename: String) async throws -> Bool {
        
        let boundary = UUID().uuidString

        var body = Data()
        
        func appendFormField(name: String, value: Any) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        appendFormField(name: "id", value: driverId)
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return false }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filename)\"; filename=\"\(filename).jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

    
        body.append("--\(boundary)--\r\n")
        
        var response: SuccessModel?
        
        do {
            response = try await postApi("/drivers/updatePhoto", method: "PUT", body: body, boundary: boundary)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response?.success ?? false
    }
    
}

// LeaveRequestView
extension APIService {
    
    func getDriverLeaveReasons() async throws -> [LeaveReasonModel.Reasons] {

        var response: [LeaveReasonModel.Reasons] = []
        
        do {
            response = try await getApi("/driverleave/reasons", model: LeaveReasonModel.self).reasons
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response
    }
    
    func postDriverLeave(fromDate: String, reason: String, toDate: String, remarks: String) async throws -> Bool {
        
        let jsonData = [
            "fromDate": fromDate,
            "reason": reason,
            "toDate": toDate,
            "remarks": remarks
        ]
        let jsonBody = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        
        var response: SuccessModel?
        
        do {
            response = try await postApi("/driverleave", method: "POST", body: jsonBody, boundary: "")
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response?.success ?? false
    }
    
}

// DocumentsView
extension APIService {
    
    func getDriverDocuments() async throws -> DriverDocumentsModel.Result {
        
        var response: DriverDocumentsModel.Result = .init()
        
        do {
            response = try await getApi("/drivers/documents/\(driverId)", model: DriverDocumentsModel.self).result!
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response
    }
    
    private func docType(urlString: String) {
        
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        
        Task {
            do {
                let _ = try await URLSession.shared.data(for: request)
            } catch {
            }
        }
        
    }
    
}

// TripsView
extension APIService {
    
    func getTripsData(startDate: String = Calendar.current.date(byAdding: .day, value: -30, to: Date())?.toString() ?? "", endDate: String = Date().toString()) async throws {
        
        do {
            tripsDataModel = try await getApi("/trips/driver/\(driverId)?sdate=\(startDate)&edate=\(endDate)", model: TripsDataModel.self)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
    
    }
    
    
    func postTripExpense(assetId: String, tripId: String, paymentMode: String, date: String, type: String, location: String, details: String, amount: String, comments: String, images: [UIImage] = []) async throws -> Bool {
        
        let boundary = UUID().uuidString

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
        appendFormField(name: "photoTimeStamp", value: Date().toString(format: "dd/MM/yyyy HH:mm:a"))
        appendFormField(name: "amount", value: amount)
        appendFormField(name: "comments", value: comments)

        
        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.3) else { break }
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"expenses_\(index + 1).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n")
        
        var response: SuccessModel?
       
        do {
            response = try await postApi("/tripexpenses/driver", method: "POST", body: body, boundary: boundary)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response?.success ?? false
    }
    
    
    func putTripExpense(assetId: String, tripId: String, expenseId: String, paymentMode: String, date: String, type: String, location: String, details: String, amount: String, comments: String, images: [UIImage] = []) async throws -> Bool {

   
        let boundary = UUID().uuidString

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
            guard let imageData = image.jpegData(compressionQuality: 0.3) else { continue }
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"expenses_\(index + 1).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n")
        
        var response: SuccessModel?
        
        do {
            response = try await postApi("/tripexpenses/driver/\(expenseId)", method: "PUT", body: body, boundary: boundary)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response?.success ?? false
    }
    
    
    func getTripExpenseZoneTypes() async throws -> [ExpenseZoneTypesModel.Results] {
        
        return try await getApi("/tripexpenses/expenseTypes", model: ExpenseZoneTypesModel.self).results
    }
    
    func getTripExpense(_ expenseId: String) async throws -> TripExpenseEditModel.Result? {
        
        var response: TripExpenseEditModel.Result?
        
        do {
            response = try await getApi("/tripexpenses/\(expenseId)", model: TripExpenseEditModel.self).result!
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response
    }
    
    
    func deleteExpenese(expenseId: Int) async throws -> Bool {
        
        var response: SuccessModel?
        
        do {
            response = try await postApi("/tripexpenses/\(expenseId)", method: "DELETE", body: Data(), boundary: "")
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response?.success ?? false
        
    }
    
}

// LeaveHistoryView
extension APIService {
    
    func getDriverLeaveHistory() {

        let url = URL(string: apiUrl + "/driverleave/history")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers

        Task {
            do {
                let _ = try await URLSession.shared.data(for: request)
            } catch {
            }
        }
    }
    
}

// check in
extension APIService {
    
    func getDriverCheckIn() async throws -> [DriverCheckInModel.Results] {
        
        var response: [DriverCheckInModel.Results] = []
        
        do {
            response = try await getApi("/driverattendances/checkIn", model: DriverCheckInModel.self).results
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response
    }
    
    func postDriverCheckIn(image: UIImage, lat: Double, lng: Double, address: String) async throws -> Bool {
        
        let boundary = UUID().uuidString

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
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return false }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"images\"; filename=\"selfieImg_\(Int(Date.timeIntervalSinceReferenceDate.rounded())).jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n")
      
        var response: SuccessModel!
        
        do {
            response = try await postApi("/driverattendances/checkIn", method: "POST", body: body, boundary: boundary)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response.success!
        
    }
}

// downloading Images
extension APIService {
    
    func downloadImage(urlString: String) async -> UIImage {
        
        var image: UIImage = .init()
        
        do {
            image = try await download(urlString: urlString)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return image
         
    }
    
    private func download(urlString: String) async throws -> UIImage {
        
        if urlString.isEmpty {
            return UIImage(imageLiteralResourceName: "id-card")
        }
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        var data: Data = .init()
        var response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                throw CustomErrorDescription.badResponse(httpResponse.statusCode)
            }
            
        } catch {
            
            if let urlError = error as? URLError {
                
                switch urlError.code {
                    
                case .notConnectedToInternet, .timedOut:
                    throw CustomErrorDescription.networkError("No internet connection")
                    
                default:
                    break
                }
            }
            
        }
        
        return UIImage(data: data) ?? .idCard
    }
}

// tripsheets
extension APIService {
    
    func getTripSheet(startDate: String = Calendar.current.date(byAdding: .day, value: -30, to: Date())?.toString() ?? "", endDate: String = Date().toString()) async throws -> TripSheetModel {
        
        var response: TripSheetModel = .init()
        
        do {
            response = try await getApi("/tripsheets/driver/\(driverId)?sdate=\(startDate)&edate=\(endDate)", model: TripSheetModel.self)
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response
        
    }
    
}

// POI view
extension APIService {
    
    func getPoiZones() async throws -> [PoiListModel.Result] {
        
        var response: [PoiListModel.Result] = []
        
        do {
            response = try await getApi("/geozones/list/PoiZones", model: PoiListModel.self).results
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response
    }
    
//    func getTollList() async throws {
//        
//        try await getApi("/drivers/listToll", model: TollListModel.self)
//    }
    
    func getFuelList() async throws -> [FuelListModel.Results] {
        
        var response: [FuelListModel.Results] = []
        
        do {
            response = try await getApi("https://kttelematic.com/images/india-fuel-small.json", model: FuelListModel.self).d
        } catch {
            alertPresenter?.error = error.localizedDescription
        }
        
        return response
    }
}


// one shared func for get api call
extension APIService {
    
    func getApi<T: Decodable>(_ urlString: String, model: T.Type) async throws -> T {
        
        var url: URL!
        
        if urlString.starts(with: "/") {
            url = URL(string: apiUrl + urlString)!
        } else {
            url = URL(string: urlString)!
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 10
        
        var data: Data = .init()
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            
            if let urlError = error as? URLError {
                switch urlError.code {
                    
                case .notConnectedToInternet, .timedOut:
                    throw CustomErrorDescription.networkError("No internet connection")
                    
                default:
                    break
                }
            }
            
        }
        
        let decoder = JSONDecoder()
        var responseModel: T

        
        let successResponse = try decoder.decode(SuccessModel.self, from: data)
        
        if successResponse.success == false {
            
            if let error = successResponse.error {
                throw CustomErrorDescription.responseError(error)
            }
            
            if let message = successResponse.message {
//                toastPresenter?.message = message
                throw CustomErrorDescription.responseError(message)
            }
            
        }
        
        do {
            responseModel = try decoder.decode(T.self, from: data)
        } catch {
            throw CustomErrorDescription.decodeError(error)
        }
        
        return responseModel
        
    }
}


// post/put/delete api call
extension APIService {
    
    func postApi(_ urlString: String, method: String, body: Data, boundary: String) async throws -> SuccessModel {
        
        let url = URL(string: apiUrl + urlString)!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        
        if !boundary.isEmpty {
            request.setValue("multipart/form-data; boundary=\(boundary)",
                             forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = body
        request.timeoutInterval = 10
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            if let urlError = error as? URLError {
                
                switch urlError.code {
                    
                case .notConnectedToInternet, .timedOut:
                    throw CustomErrorDescription.networkError("No internet connection")
                    
                default:
                    break
                }
            }
            throw error
        }
        
        let decoder = JSONDecoder()
        
        print(response)
        
        var responseModel: SuccessModel!
        
       
        responseModel = try decoder.decode(SuccessModel.self, from: data)
        
        print(responseModel as Any)
        
        if let error = responseModel.error {
            throw CustomErrorDescription.responseError(error)
        }
    
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
            throw CustomErrorDescription.badResponse(httpResponse.statusCode)
        }
    
        
        return responseModel
        
    }
    
}

