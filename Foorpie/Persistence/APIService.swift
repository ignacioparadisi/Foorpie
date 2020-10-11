//
//  APIManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/23/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class APIService {
    
    // MARK: Properties
    /// APIManager Singleton instance
    static var shared: APIService = APIService()
    
    // MARK: Initializer
    private init() {}
    
    // MARK: Functions
    /// Decodes a data object into a class that conforms the Decodable protocol
    /// - Parameters:
    ///   - objectType: Type of objet to create from the data
    ///   - data: Data to be decoded
    /// - Throws: Error when trying to decode
    /// - Returns: The decoded object
    func decode<T: Decodable>(_ objectType: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(objectType, from: data)
        return decodedObject
    }
    
    
    /// Encodes an object that conforms the Encodable protocol into Data
    /// - Parameter value: Object to be decoded
    /// - Throws: Error when trying to decode
    /// - Returns: The encoded data
    func encode<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }
    
    /// Makes an http requests
    /// - Parameters:
    ///   - url: URL Where the request is made
    ///   - method: Method for the request
    ///   - body: Body for the request
    ///   - result: Response of the request
    func makeRequest<E: Encodable, D: Decodable>(url: URL, method: HTTPMethod, body: E? = nil, result: @escaping (Result<D, Error>) -> Void) {
        let request = createRequest(url: url, method: method, body: try? encode(body))
        let task = createDataTask(for: request, result: result)
        task.resume()
    }
    
    /// Makes an http requests without body
    /// - Parameters:
    ///   - url: URL Where the request is made
    ///   - method: Method for the request
    ///   - result: Response of the request
    func makeRequest<D: Decodable>(url: URL, method: HTTPMethod, result: @escaping (Result<D, Error>) -> Void) {
        let request = createRequest(url: url, method: method)
        let task = createDataTask(for: request, result: result)
        task.resume()
    }
    
    
    /// Creates an URLRequest with the required headers, URL, HTTP Method and body
    /// - Parameters:
    ///   - url: URL for the request
    ///   - method: HTTP Method for the request
    ///   - body: Body for the request
    /// - Returns: A URLRequest
    private func createRequest(url: URL, method: HTTPMethod, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(Locale.current.languageCode, forHTTPHeaderField: "Accept-Language")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let user = UserDefaults.standard.user {
            request.setValue(user.token, forHTTPHeaderField: "X-Auth-Token")
        }
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
    
    /// Creates a data task for making a http requests. It also handles the errors coming from the server or from the connection
    /// - Parameters:
    ///   - request: Request to be made
    ///   - result: Result coming from the server or error.
    /// - Returns: A data task to make requests.
    private func createDataTask<D: Decodable>(for request: URLRequest, result: @escaping (Result<D, Error>) -> Void) -> URLSessionDataTask {
        let session = URLSession.shared
        return session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            // Check if an error exists to return the error.
            if let error = error {
                if let apiError = error as? APIError {
                    DispatchQueue.main.async {
                        result(.failure(apiError))
                    }
                } else {
                    DispatchQueue.main.async {
                        result(.failure(APIError.apiError(error.localizedDescription)))
                    }
                }
                return
            }
            // If data is null return an error.
            guard let data = data else {
                DispatchQueue.main.async {
                    result(.failure(APIError.unknown))
                }
                return
            }
            // Check is status code is not between 200 and 300. If that's the case, then the data should be an error.
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                // Check is the error is a validation error from the backend
                if let errors = try? self.decode([APIValidationError].self, from: data) {
                    DispatchQueue.main.async {
                        result(.failure(APIError.apiValidationError(errors)))
                    }
                    return
                }
                DispatchQueue.main.async {
                    result(.failure(APIError.unknown))
                }
                return
            }
            // Return the data if everything is OK.
            do {
                let object = try self.decode(D.self, from: data)
                DispatchQueue.main.async {
                    result(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    result(.failure(error))
                }
            }
        })
    }
}

// MARK: - HTTPMethod
extension APIService {

    struct HTTPMethod: RawRepresentable, Equatable, Hashable {
        /// `CONNECT` method.
        public static let connect = HTTPMethod(rawValue: "CONNECT")
        /// `DELETE` method.
        public static let delete = HTTPMethod(rawValue: "DELETE")
        /// `GET` method.
        public static let get = HTTPMethod(rawValue: "GET")
        /// `HEAD` method.
        public static let head = HTTPMethod(rawValue: "HEAD")
        /// `OPTIONS` method.
        public static let options = HTTPMethod(rawValue: "OPTIONS")
        /// `PATCH` method.
        public static let patch = HTTPMethod(rawValue: "PATCH")
        /// `POST` method.
        public static let post = HTTPMethod(rawValue: "POST")
        /// `PUT` method.
        public static let put = HTTPMethod(rawValue: "PUT")
        /// `TRACE` method.
        public static let trace = HTTPMethod(rawValue: "TRACE")

        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
}

// MARK: - APIError
extension APIService {
    enum APIError: Error, LocalizedError {
        case unknown
        case apiError(String)
        case apiValidationError([APIValidationError])
        var errorDescription: String? {
                switch self {
                case .unknown:
                    return "Unknown error"
                case .apiError(let reason):
                    return reason
                case .apiValidationError(let errors):
                    var message = ""
                    for error in errors {
                        message += "\(error.message)\n"
                    }
                    return message
                }
            }
    }
}
