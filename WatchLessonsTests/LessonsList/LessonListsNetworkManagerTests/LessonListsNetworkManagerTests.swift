//
//  LessonListsNetworkManagerTests.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 01/03/2023.
//

import Combine
import XCTest
@testable import WatchLessons

final class LessonListsNetworkManagerTests: XCTestCase {
    
    var sut: LessonListsNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override class func setUp() {
        let mockResponse = HTTPURLResponse(url: URL(string: APIHelper.getLessnonsListURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = mockResponse
    }
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        sut = LessonListsNetworkManager(urlSession: session)
        cancellables = Set()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(MockURLProtocol.self)
        cancellables = []
        MockURLProtocol.error = nil
        MockURLProtocol.mockResponseData = nil
    }
    
    func testFetchData_WhenCallAPI_ReceiveCorrectJSONResponse() {
        
        // Arrange
        let jsonString = """
            {
                "lessons": [
                    {
                        "id": 1,
                        "name": "Lesson 1",
                        "description": "Description 1",
                        "thumbnail": "Thumbnail 1",
                        "videoUrl": "Video URL 1"
                    },
                    {
                        "id": 2,
                        "name": "Lesson 2",
                        "description": "Description 2",
                        "thumbnail": "Thumbnail 2",
                        "videoUrl": "Video URL 2"
                    }
                ]
            }
        """
        
        let mockData = jsonString.data(using: .utf8)!
        MockURLProtocol.mockResponseData = mockData
        
        let expectation = self.expectation(description: "API Reponse Expectation")
        
        // Act
        sut.fetchData()
            .sink { completion in
                
                switch completion {
                    
                case .finished:
                    expectation.fulfill()
                    
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                }
                
            } receiveValue: { lessons in
                
                // Assert
                XCTAssertEqual(lessons.lessons.count, 2)
                XCTAssertEqual(lessons.lessons[0].name, "Lesson 1")
                XCTAssertEqual(lessons.lessons[1].name, "Lesson 2")
            }
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchData_WhenCallAPI_ReceiveDifferentJSONResponse() {
        
        // Arrange
        let jsonString = """
            {
                "id": "100",
                "required": true,
                "position": 10
            }
        """
        
        let mockData = jsonString.data(using: .utf8)!
        MockURLProtocol.mockResponseData = mockData
        
        let expectation = self.expectation(description: "Fetch Data expecation for response if JSON is different")
        
        // Act
        sut.fetchData()
            .sink { completion in
                
                switch completion {
                    
                case .finished:
                    XCTFail("Should return error for different json")
                    
                case .failure(let error):
                    
                    // Assert
                    XCTAssertEqual(error, .decodingFailed, "The error is not as expected. It should be unable to decode the JSON")
                    expectation.fulfill()
                }
                
            } receiveValue: { _ in}
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchData_WhenGivenEmptyURL_ShouldReturnError() {
        
        // Arrange
        sut = LessonListsNetworkManager(url: "")
        
        let expectation = self.expectation(description: "Fetch Data expectation when url is empty string")
        
        // Act
        sut.fetchData()
            .sink { completion in
                
                switch completion {
                    
                case .finished:
                    XCTFail("Should return error for empty url")
                    
                case .failure(let error):

                    // Assert
                    XCTAssertEqual(error, .emptyURL, "The error is not as expected. It should be that the provided URL is empty string")
                    expectation.fulfill()
                }
                
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchData_WhenRequestFails_ShouldReturnError() {
        
        // Arrange
        let expectation = self.expectation(description: "Failed request expectation")
        MockURLProtocol.error = Error.failedRequest
        
        // Act
        sut.fetchData()
            .sink { completion in
                
                switch completion {
                    
                case .finished:
                    XCTFail("Should return error for failed request")
                    
                case .failure(let error):
                   
                    // Assert
                    XCTAssertEqual(error, .failedRequest)
                    expectation.fulfill()
                }
                
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 2.0)
    }
    
    // Integration Testing
    //    func testAPIWorking() {
    //        let expectation = self.expectation(description: "expectation fulfiled")
    //
    //        var cancellable: AnyCancellable?
    //        cancellable = sut.fetchData().sink { completion in
    //
    //            switch completion {
    //
    //            case .finished:
    //                expectation.fulfill()
    //                cancellable?.cancel()
    //
    //            case .failure(_):
    //                XCTFail("Fail")
    //            }
    //
    //        } receiveValue: { _ in
    //
    //        }
    //
    //        self.waitForExpectations(timeout: 5)
    //    }
}
