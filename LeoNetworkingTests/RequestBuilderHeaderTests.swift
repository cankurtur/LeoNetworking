//
//  RequestBuilderHeaderTests.swift
//  LeoNetworkingTests
//
//  Created by Can Kurtur on 2.05.2023.
//

@testable import LeoNetworking
import XCTest

final class RequestBuilderHeaderTests: XCTestCase {
    /// Note: Plese check `MockEndpoint` file, baseURL etc implemented in an extension.
    enum MockRequest: Endpoint {
        case fetchMovies
        
        var path: String {
        return "movies"
        }
        
        var params: [String : Any]? {
            return nil
        }
        
        var method: HTTPMethod {
            return .get
        }
    }
    
    func testHeaders() {
        let request = RequestBuilder.makeRequest(
            for: MockRequest.fetchMovies,
            timeoutInterval: 10
        )
        
        /// Token provided inside `MockEndpoint`.
        XCTAssertEqual(request?.allHTTPHeaderFields,
            HTTPHeaders(headers: [
                HTTPHeader(name: "Accept", value: "application/json"),
                HTTPHeader(name: "Cache-Control", value: "no-cache"),
                HTTPHeader(name: "Content-Type", value: "application/json"),
                HTTPHeader(name: "Authorization", value: "Test token")
            ]).asDictionary
        )
    }
}
