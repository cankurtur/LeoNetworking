//
//  URLResponseExtension.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//

import Foundation

extension URLResponse {
    /// Represents status code of the request.
    var code: Int? {
        guard let response = self as? HTTPURLResponse else {
            return nil
        }
        
        return response.statusCode
    }
}
