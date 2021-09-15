//
//  File.swift
//  
//
//  Created by Mark Struzinski on 6/15/19.
//

import XCTest
import Prch
@testable import ITunesServicesKit

final class ITunesNetworkClientTests: XCTestCase {
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        session = URLSession(configuration: config)
    }
    
    func testSearchRequest() {
      let client = APIClient(api: iTunes(), session: URLSession.shared)
      
      
      let iTunesExpectation = expectation(description: "Itunes Search Request")
      
      client.request(Request(term: "test")) { result in
        iTunesExpectation.fulfill()
                    switch result {
                    case .success(.status200(let response)):
                        XCTAssertEqual(response.results.count, 2, "2 results should be returned")
                    default:
                        XCTFail("Search result should be returned")
                    }
      }
//        let client = ITunesNetworkClient(urlSession: session)
//
//        
//        client.search(for: "test") { result in
//            iTunesExpectation.fulfill()
//            
//            switch result {
//            case .success(let response):
//                XCTAssertEqual(response.results.count, 2, "2 results should be returned")
//            case .failure:
//                XCTFail("Search result should be returned")
//            }
//        }
//        
       wait(for: [iTunesExpectation], timeout: 5.0)
    }
    
    static var allTests = [
        ("testSearchRequest", testSearchRequest)
    ]

}
