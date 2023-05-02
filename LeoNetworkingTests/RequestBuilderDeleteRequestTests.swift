//
//  RequestBuilderDeleteRequestTests.swift
//  LeoNetworkingTests
//
//  Created by Can Kurtur on 2.05.2023.
//

@testable import LeoNetworking
import XCTest

final class RequestBuilderDeleteRequestTests: XCTestCase {
    /// Note: Plese check `MockEndpoint` file, baseURL etc implemented in an extension.
    enum MockDeleteRequests: Endpoint {
        case deleteMovie(MovieDeleteRequestData)
        
        var path: String {
            return "movie"
        }
        
        var params: [String : Any]? {
            switch self {
            case .deleteMovie(let data): return data.asDictionary
            }
        }
        
        var method: HTTPMethod {
            return .delete
        }
    }
    
    struct MovieDeleteRequestData: Encodable {
        let id: Int
    }
    
    func testDeleteRequest() {
        let data: MovieDeleteRequestData = .init(id: 8)
        
        let request = RequestBuilder.makeRequest(
            for: MockDeleteRequests.deleteMovie(data),
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertEqual(request?.timeoutInterval, 10)
        XCTAssertEqual(request?.url?.absoluteString, "https://www.testapi.com/movie")
        XCTAssertEqual(request!.httpBody!.prettyPrintedJSONString!,
            """
            {
              "id" : 8
            }
            """
        )
    }
}
