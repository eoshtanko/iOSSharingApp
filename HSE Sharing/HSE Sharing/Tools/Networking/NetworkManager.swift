//
//  NetworkManager.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import Foundation
import Alamofire

class Api {
    
    static let shared = Api()
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let baseURL = "https://sharingskillsapp.azurewebsites.net"
    let headers = [
        "Content-type": "application/json",
        "Accept": "application/json"]
    
    init() {
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
        encoder.dateEncodingStrategy = .formatted(Formatter.iso8601)
    }
    
    enum Result<T> {
        case success(T?)
        case failure(Error)
    }
    
    enum HttpMethod: String {
        case DELETE
        case POST
        case GET
        case PUT
    }
    
    func createSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)
        return session
    }
    
    func createRequest(url: URL, httpMethod: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = self.headers
        return request
    }
}

