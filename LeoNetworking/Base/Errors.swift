//
//  Errors.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//
import Foundation

/// Generic error type for error layer, provide your own type with confirming this protocol
/// to be able to cast network error to your own error model.
public protocol APIError: Codable {
    var error: BaseError { get }
}

public protocol BaseError: Codable, AnyObject {
    var message: String { get set }
}

/// Concrete API error type.
public enum APIClientError: Error {
    case handledError(apiError: APIError)
    case networkError
    case decoding(error: DecodingError?)
    case timeout
    case invalidStatusCode
    case badRequest
    
    public var message: String {
        switch self {
        case .handledError(let apiError):
            return apiError.error.message
        case .decoding:
            return "Decoding Error"
        case .networkError:
            return "Connection Error"
        case .timeout:
            return "Timeout"
        case .invalidStatusCode:
            return "Invalid status code"
        case .badRequest:
            return "Bad request"
        }
    }

    public var debugMessage: String {
        switch self {
        case .handledError(let apiError):
            return apiError.error.message
        case .networkError:
            return "Network error"
        case .decoding(let decodingError):
            guard let decodingError = decodingError else { return "Decoding Error" }
            return "\(decodingError)"
        case .timeout:
            return "Timeout"
        case .invalidStatusCode:
            return "Invalid status code"
        case .badRequest:
            return "Bad request"
        }
    }
    
    public var statusCode: Int {
        switch self {
        case .handledError:
            return 0
        case .networkError:
            return 400
        case .decoding:
            return NSURLErrorCannotDecodeRawData
        case .timeout:
            return NSURLErrorTimedOut
        case .invalidStatusCode:
            return 0
        case .badRequest:
            return 0
        }
    }
}
