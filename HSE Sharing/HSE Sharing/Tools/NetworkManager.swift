//
//  NetworkManager.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import Foundation
import Alamofire

class Api1 {
    
    static let shared = Api1()
    
    private let decoder = JSONDecoder()
    private let baseURL = "https://sharingskillsapp.azurewebsites.net"
    private let headers = [
        "Content-type": "application/json",
        "Accept": "application/json"]
    
    init() {
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
    }
    
    enum Result<T> {
        case success(T?)
        case failure(Error)
    }
    
    enum ApiError: Error {
           case couldNotParse
           case badResponse
    }
    
    enum HttpMethod: String {
        case DELETE
        case POST
        case GET
        case PUT
    }
    
    private func createSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)
        return session
    }
    
    private func createRequest(url: URL, httpMethod: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = self.headers
        return request
    }
    
    func recoveryUsersPassword(email: String, completion: @escaping () -> Void) {
        let url = URL(string: "\(baseURL)/api/Users/\(email)/password")!
        print("\(baseURL)/api/Users/\(email)/password")
        Alamofire.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    completion()
                case .failure(let error):
                    print(error)
                    completion()

                }
            }
        
//        let session = URLSession.shared
//        let url = URL(string: "\(baseURL)/api/Users/\(email)/password")!
//
//        let task = session.dataTask(with: url) { data, response, error in
//
//            if let error = error {
//                print(error)
//            }
//
//            guard let response = response as? HTTPURLResponse,
//                  (200...299).contains(response.statusCode) else {
//                      if let response = response as? HTTPURLResponse {
//                          print(response.statusCode)
//                      }
//                      print("Server error!")
//                      return
//                  }
//            if response.statusCode == 400 {
//                print("Нет такого")
//                return
//            }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print("The Response is : ",json)
//            } catch {
//                print("JSON error: \(error.localizedDescription)")
//            }
//        }
//
//        task.resume()
    }
    
    func deleteUser(email: String, completion: @escaping () -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(email)")!
        let request = createRequest(url: url, httpMethod: .DELETE)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Oops!! there is server error!")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("The Response is : ",json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func getUserByEmail(email: String, _ completion: @escaping (Result<User>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(email)")!
        let request = createRequest(url: url, httpMethod: .GET)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("The Response is : ",json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func createUser(_ completion: @escaping (Result<User>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/")!
        var request = createRequest(url: url, httpMethod: .POST)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: CurrentUser.user.toDictInitial, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            guard let safeData = data else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            let jsonData = Data(safeData)
            guard let result = try? self.decoder.decode(User.self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
}

extension Formatter {
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}
