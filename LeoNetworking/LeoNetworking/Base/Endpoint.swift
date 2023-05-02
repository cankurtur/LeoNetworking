//
//  Endpoint.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//

import Foundation

public protocol Endpoint: CustomStringConvertible {
    var baseUrl: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    var baseHeaders: HTTPHeaders? { get }
    var url: String { get }
    var method: HTTPMethod { get }
}

public extension Endpoint {
    var description: String {
        var descriptionString = ""
        descriptionString.append(contentsOf: "\nURL: [\(method.rawValue)] \(url)")
        descriptionString.append(contentsOf: "\nHEADERS: \(headers ?? HTTPHeaders())")
        descriptionString.append(contentsOf: "\nPARAMETERS: \(String(describing: params ?? [:]))")
        return descriptionString
    }
    
    var baseHeaders: HTTPHeaders? {
        let acceptHeader = HTTPHeader(name: "Accept", value: "application/json")
        let cacheHeader = HTTPHeader(name: "Cache-Control", value: "no-cache")
        let contentTypeHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        
        return HTTPHeaders(
            headers: [acceptHeader, cacheHeader, contentTypeHeader]
        )
    }
}

public extension HTTPMethod {
    var encoding: ParameterEncoding {
        switch self {
        case .get:
            return .url
        default:
            return .json
        }
    }
}
