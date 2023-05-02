//
//  MockEndpoint.swift
//  LeoNetworkingTests
//
//  Created by Can Kurtur on 2.05.2023.
//

@testable import LeoNetworking
import Foundation

extension Endpoint {
    var baseUrl: String {
        return "https://www.testapi.com/"
    }
    
    var params: [String: Any]? {
        return nil
    }
    
    var url: String {
        return "\(baseUrl)\(path)"
    }
    
    var headers: HTTPHeaders? {
        var headers = baseHeaders
        let authHeader = HTTPHeader(name: "Authorization", value: "Test token")
        headers?.add(authHeader)
        return headers
    }
}
