//
//  HTTPHeaders.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//

import Foundation

/// An order-preserving and case-insensitive representation of HTTP headers.
public struct HTTPHeaders {
    private var headers: [HTTPHeader] = []

    /// Creates an empty instance.
    public init() {}
    
    /// Dictionary representation of the header.
    public var asDictionary: [String: String] {
        var dictionary: [String: String] = [:]
        
        headers.forEach { header in
            dictionary[header.name] = header.value
        }
        return dictionary
    }

    /// Creates an instance from an array of `HTTPHeader`s.
    public init(headers: [HTTPHeader]) {
        self.init()

        self.headers = headers
    }
    
    /// Adds specific header into headers.
    /// - Parameter header: Given header.
    public mutating func add(_ header: HTTPHeader) {
        self.headers.append(header)
    }
    
    /// Embeds the headers into given url request.
    /// - Parameter request: Given url request.
    /// - Returns: Updated url request.
    public func embed(into request: URLRequest) -> URLRequest {
        var request = request
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return request
    }
}
