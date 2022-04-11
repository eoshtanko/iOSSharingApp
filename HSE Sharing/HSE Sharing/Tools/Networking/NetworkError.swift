//
//  NetworkError.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.04.2022.
//

import Foundation

enum ApiError: Error {
    case couldNotParse
    case badResponse
    case noSuchData
}
