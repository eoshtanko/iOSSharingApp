//
//  NetworkManager.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import Foundation

class NetworkManager {
    
    enum Result<T> {
        case success(T?)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
}
