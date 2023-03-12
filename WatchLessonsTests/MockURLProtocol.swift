//
//  MockURLProtocol.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 09/03/2023.
//

import Foundation
//import Combine

class MockURLProtocol: URLProtocol {

    static var mockResponseData: Data?
    static var mockResponse: HTTPURLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let mockResponse = MockURLProtocol.mockResponse else {
            fatalError("Response not set")
        }

        self.client?.urlProtocol(self, didReceive: mockResponse, cacheStoragePolicy: .notAllowed)
        
        
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
            
        } else {
             
            if let mockData = MockURLProtocol.mockResponseData {
                self.client?.urlProtocol(self, didLoad: mockData)
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
