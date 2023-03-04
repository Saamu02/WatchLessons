//
//  WatchLessonsTests.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 01/03/2023.
//

import Combine
import XCTest
@testable import WatchLessons

final class WatchLessonsTests: XCTestCase {

    func testAPIWorking() {
        let expectation = self.expectation(description: "expectation fulfiled")
        
        var cancellableSet: Set<AnyCancellable> = []

        NetworkManager.shared.fetchData().sink { completion in
            
            switch completion {
                
            case .finished:
                expectation.fulfill()
                
            case .failure(_):
                XCTFail("Fail")
            }
            
        } receiveValue: { _ in

        }.store(in: &cancellableSet)
        
        self.waitForExpectations(timeout: 5)
    }
}
