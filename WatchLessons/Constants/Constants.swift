//
//  Constants.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 03/03/2023.
//

import Foundation

enum ErrorDescription {
    static let noInternetConnect = "No Internet Connection"
    static let someThingWentWrong = "Something went wrong while fetching data from the server. \nPlease try again later"
}


enum Error: LocalizedError, Equatable {
    
    case addressUnreachable(URL)
    case invalidResponse
    case decodingFailed
    case failedRequest
    case emptyURL
    case failFetchingDataFromCoreData
    
    var errorDescription: String? {
        
        switch self {
            
        case .addressUnreachable:
            return "Couldn't reach the server"
            
        case .invalidResponse:
            return "The data couldn’t be read because it is missing."
            
        case .decodingFailed:
            return "Unable to decode JSON data"
            
        case .failedRequest:
            return "Failed Request"
            
        case .emptyURL:
            return "The provided URL is empty string."
            
        case .failFetchingDataFromCoreData:
            return "Couldn't fetch data from the Core Data"
        }
    }
}
