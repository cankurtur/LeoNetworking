//
//  RequestBuilderGetRequestTests.swift
//  LeoNetworkingTests
//
//  Created by Can Kurtur on 2.05.2023.
//


@testable import LeoNetworking
import XCTest

final class RequestBuilderGetRequestTests: XCTestCase {
    /// Note: Plese check `MockEndpoint` file, baseURL etc implemented in an extension.
    enum MockGetRequests: Endpoint {
        case fetchMovie(movieId: Int)
        case fetchMovies
        /// This request is needed to show providing parameter in `path` and `params` is the same.
        case fetchDirector(id: Int)
        
        var path: String {
            switch self {
            case .fetchMovie: return "movie"
            case .fetchMovies: return "movies"
            case .fetchDirector(let id): return "director?id=\(id)"
            }
        }
        
        var params: [String : Any]? {
            switch self {
            case .fetchMovie(let id): return ["id": id]
            case .fetchMovies: return nil
            case .fetchDirector: return nil
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
    }
    
    func testRequestWithParams() {
        let request = RequestBuilder.makeRequest(
            for: MockGetRequests.fetchMovie(movieId: 12),
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.timeoutInterval, 10)
        XCTAssertEqual(request?.url?.absoluteString, "https://www.testapi.com/movie?id=12")
        XCTAssertEqual(request?.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func testRequestWithParamsInPath() {
        let request = RequestBuilder.makeRequest(
            for: MockGetRequests.fetchDirector(id: 1),
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://www.testapi.com/director?id=1")
        XCTAssertEqual(request?.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request?.timeoutInterval, 10)
    }
}

