//
//  NetworkingManager.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//

import Foundation

/// Network manager that provides request methods for both callback and new async/await API.
public final class NetworkManager: NetworkManagerProtocol {
    let session: URLSession
    
    /// Custom error type that provided by consumer.
    private let clientErrorType: APIError.Type
    
    /// Callback for `errorStatusCodesToTrack`.
    private let errorStatusCodeHandler: ErrorStatusCodeHandler?
    
    /// Timeout interval per each request.
    private let timeoutInterval: TimeInterval
    
    /// Contains specific error codes to notify
    /// consumers when request's status code is in the list.
    /// Use `errorStatusCodeHandler` to listen these status codes in consumer side.
    private let errorStatusCodesToTrack: [Int]
    
    /// Provides status codes for success cases, it is used
    /// to check if request failed or not.
    private var successStatusCodes: ClosedRange<Int> {
        return 200...209
    }
    
    /// Default, single, decoder for all of the requests.
    private lazy var decoder: JSONDecoder = {
        return .init()
    }()
    
    public init(
        session: URLSession = .shared,
        timeoutInterval: TimeInterval = 10,
        clientErrorType: APIError.Type,
        errorStatusCodesToTrack: [Int] = [],
        errorStatusCodeHandler: ErrorStatusCodeHandler? = nil
    ) {
        self.session = session
        self.timeoutInterval = timeoutInterval
        self.clientErrorType = clientErrorType
        self.errorStatusCodesToTrack = errorStatusCodesToTrack
        self.errorStatusCodeHandler = errorStatusCodeHandler
    }
        
    /// Sends request with new async/await API.
    /// - Parameters:
    ///   - endpoint: Given endpoint.
    ///   - responseType: Response type provided by consumer.
    /// - Returns: Decoded T type object.
    @MainActor
    public func request<T>(
        endpoint: some Endpoint,
        responseType: T.Type
    ) async throws -> T where T : Decodable {
        
        guard let request = RequestBuilder.makeRequest(for: endpoint, timeoutInterval: timeoutInterval) else {
            throw APIClientError.badRequest
        }
                
        do {
            let (data, response) =  try await session.data(for: request)
            
            guard let statusCode = response.code else {
                throw APIClientError.invalidStatusCode
            }
            
            if successStatusCodes.contains(statusCode) {
                return try await handleSucceedRequest(from: data, endpoint: endpoint, responseType: responseType)
            } else {
                throw await handleFailedRequest(from: response, data: data, endpoint: endpoint)
            }
        } catch let error as NSError {
            throw error
        }
    }
    
    /// Sends requests with callbacks.
    /// - Parameters:
    ///   - endpoint: Given endpoint.
    ///   - responseType: Response type provided by consumer.
    ///   - completion: Completion block.
    @MainActor
    public func request<T>(
        endpoint: some Endpoint,
        responseType: T.Type,
        completion: @escaping NetworkHandler<T>
    ) where T : Decodable {
        Task {
            do {
                let response = try await request(endpoint: endpoint, responseType: responseType)
                completion(.success(response))
            } catch let error as APIClientError {
                completion(.failure(error))
            } catch {
                completion(.failure(.networkError))
            }
        }
    }
}

// MARK: - Internal methods

private extension NetworkManager {

    /// /// Handles success case from API request.
    /// - Parameters:
    ///   - data: Given data from request.
    ///   - endpoint: Given endpoint.
    ///   - responseType: Response type provided by consumer.
    /// - Returns: Decoded T type object.
    private func handleSucceedRequest<T: Decodable>(
        from data: Data,
        endpoint: some Endpoint,
        responseType: T.Type
    ) async throws -> T where T : Decodable {
        guard !data.isEmpty else {
            return EmptyResponse() as! T
        }
        
        do {
            let decodedObject = try self.decoder.decode(responseType, from: data)
            return decodedObject
        } catch {
            let decodingError = APIClientError.decoding(error: error as? DecodingError)
            throw decodingError
        }
    }
        
    /// Handles failure case from API request.
    /// - Parameters:
    ///   - response: Given response.
    ///   - data: Given data from request.
    ///   - endpoint: Given endpoint.
    /// - Returns: Generic APIClientError for all of the consumers
    private func handleFailedRequest(
        from response: URLResponse,
        data: Data?,
        endpoint: some Endpoint
    ) async -> APIClientError {
        guard response.code != NSURLErrorTimedOut else {
            return APIClientError.timeout
        }
        
        /// Triggers handler when error's status code is in *errorStatusCodesToTrack*.
        if let statusCode = response.code, errorStatusCodesToTrack.contains(statusCode) {
            errorStatusCodeHandler?(statusCode)
        }
        
        do {
            guard let data = data else {
                return APIClientError.networkError
            }
            
            let clientError = try self.decoder.decode(self.clientErrorType, from: data)
            clientError.statusCode = response.code
            return APIClientError.handledError(error: clientError)
        } catch {
            let decodingError = APIClientError.decoding(error: error as? DecodingError)
            return decodingError
        }
    }
}
