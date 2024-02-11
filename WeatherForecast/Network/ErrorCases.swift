//
//  ErrorCases.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import Foundation

enum ErrorCases: LocalizedError {
    case invalidBaseURL
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "invalidURL found"
                
            case .invalidResponse:
                return "Invalid Response found"
                
            case .invalidData:
                return "Invalid Data found"
                
            case .invalidBaseURL:
                return "InvalidBaseURL found"
        }
    }
}
