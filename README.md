# LeoNetworking

LeoNetworking is a powerful networking framework that simplifies the process of making network requests and handling errors in Swift. With LeoNetworking, you can easily make network requests and handle any errors that occur, making it the perfect tool for building robust applications that rely on networking.
## Table of contents
- :mag: [Requirements](#requirements)
- :rocket: [Installation](#installation)
- :books: [Usage](#usage)
- :key: [Licence](#licence)

## Requirements

LeoNetworking is written in Swift 5.0+ and compatible with iOS 15.0+.

## Installation

### Swift Package Manager

1. In Xcode, select File > Swift Packages > Add Package Dependency.
1. Follow the prompts using the URL for this repository
1. Select the `LeoNetworking`-prefixed libraries you want to use
1. Check-out the version that you want
1. Start coding!

## Usage

The LeoNetworking framework provides functionality for handling network requests and errors in Swift.

### Import 
```swift
import LeoNetworking
```

### Type Aliases (Optional)
```swift
public typealias EmptyResponse = LeoNetworking.EmptyResponse
public typealias APIClientError = LeoNetworking.APIClientError
public typealias NetworkManagerProtocol = LeoNetworking.NetworkManagerProtocol
public typealias BaseError = LeoNetworking.BaseError
```


- `EmptyResponse`: a type alias for `LeoNetworking.EmptyResponse`, which represents an empty HTTP response.
- `APIClientError`: a type alias for `LeoNetworking.APIClientError`, which represents errors that can occur during API client operations.
- `NetworkManagerProtocol`: a type alias for `LeoNetworking.NetworkManagerProtocol`, which defines a protocol for a network manager that can handle network requests.
- `BaseError`: a type alias for `LeoNetworking.BaseError`, which represents the base error type for the framework.

### Creating Instance

```swift
final class TestClass {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(clientErrorType: ClientError.self)) {
        self.networkManager = networkManager
    }
}

```
The `TestClass` class is an example of how to use the `NetworkManagerProtocol` provided by the LeoNetworking framework. It has a private property called networkManager that is of type `NetworkManagerProtocol`.

The `TestClass` class also has an initializer that takes an optional parameter of type NetworkManagerProtocol, which defaults to a new `NetworkManager` instance with a `ClientError` type specified.

This class can be used as a starting point for implementing network functionality in an application.

### Endpoint Extension
```swift
import LeoNetworking

public extension Endpoint {
    var baseUrl: String {
        return "https://localhost/3000"
    }
    
    var params: [String: Any]? {
        return nil
    }
    
    var url: String {
        return "\(baseUrl)\(path)"
    }
    
    var headers: HTTPHeaders? {
        var headers = baseHeaders
        return headers
    }
}
```
`Endpoint` struct provided by the `LeoNetworking` framework. It adds some default behavior for properties that need to be implemented by endpoints that conform to this protocol.

- The `baseUrl` property returns the abstract API base URL.
- The `params` property returns a nil value as there are no default parameters for this endpoint.
- The `url` property returns the full URL of the endpoint by concatenating the base URL and the endpoint's path.
- The `headers` property returns a `HTTPHeaders` object containing the base headers defined in the `baseHeaders` property.
- The `path` propert provided by `LeoNetworking`.

These default implementations allow for easier and more concise endpoint implementations, while still providing the flexibility to override them where needed.

### Client Error
Generic error type for error layer, provide your own type with confirming this protocol to be able to cast network error to your own error model.

```swift
import LeoNetworking

public class ClientError: APIError {
    public var error: BaseError
}
```

### Implementation
Create your own `EndpointItem` upon your need. 

```swift
import LeoNetworking

enum TestEndPointItem: Endpoint {
case testRequest(date: String)
    
    var path: String {
        switch self {
        case .testRequest(let date):
            return "/testPath?date=\(date)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .testRequest:
            return .get
        }
    }
}
```

### Response 
Create your own response object upon your need.
```swift
import Foundation

struct TestResponse: Codable {
    let success: Bool?
}
```

### Request
Create your own test function and give a response object as the `responseType`.

```swift
final class TestClass {
    ...
    
    func testRequest(date: String) {
        networkManager.request(
            endpoint: TestEndpointItem.testRequest(
                date: date
            ),
            responseType: TestResponse.self) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    print(response.success)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

```
## Licence

`LeoNetworking` is available under the MIT license. See the LICENSE file for more info.



