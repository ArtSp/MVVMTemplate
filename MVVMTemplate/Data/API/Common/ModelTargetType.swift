//
//  ModelTargetType.swift
//  MVVMTemplate

import Foundation
import Moya
import CombineMoya
import Combine

typealias TargetMethod = Moya.Method

// MARK: - Protocols

/// `TargetType` with typealias `T: JSONJoy`
protocol ModelTargetType: TargetType { associatedtype Response: Decodable }

/// `TargetType` with success type
protocol SuccessTargetType: TargetType {}

/// Prevents showing automatic error
protocol HandlesErrorsLocaly {}

/// Request does not require token
protocol IsUnauthorized {}

/// Use on Moya,TargetType to specify date decoding strategy
protocol CustomDateDecodable {
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}
/// Use on Moya,TargetType to specify date encoding strategy
protocol CustomDateEncodable {
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get }
}

protocol CustomDateCodable: CustomDateEncodable & CustomDateDecodable {}

// MARK: - TargetType

protocol TargetType: Moya.TargetType {
    var method: TargetMethod { get }
    var request: TargetRequest? { get }
    var encoding: URLEncoding? { get }
    var baseURL: URL { get }
}

extension TargetType {
    var request: TargetRequest? { nil }
    var encoding: URLEncoding? { nil }
    
    var baseURL: URL {
        switch request {
        case let .queryParameters(queryParameters):
            return API.baseUlrWithAddedQueryParameters(queryParameters)
        default:
            return API.baseURL
        }
    }
    
    var task: Moya.Task {
        switch request {
        case let .multipart(data): return .uploadMultipart(data)
        case let .parameters(parameters): return .requestParameters(parameters: parameters, encoding: encoding ?? JSONEncoding.default)
        case let .encodable(encodable): return .requestCustomJSONEncodable(encodable, encoder: encoder)
        case let .data(data): return .requestData(data)
        case .none, .queryParameters: return .requestPlain
        }
    }
}

// MARK: - TargetRequest

enum TargetRequest {
    case parameters([String: Any])
    case queryParameters([String: String?])
    case multipart([MultipartFormData])
    case data(Data)
    case encodable(Encodable)
}

// MARK: - Coders

extension Moya.TargetType {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = (self as? CustomDateDecodable)?.dateDecodingStrategy ?? .default
        return decoder
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = (self as? CustomDateEncodable)?.dateEncodingStrategy ?? .default
        return encoder
    }
}

// MARK: - request() methods

extension ModelTargetType where Self: Moya.TargetType {
    
    func request() -> AnyPublisher<Response, API.Error> {
        CombineMoyaProviderRequest(self)
            .map(Response.self, using: decoder)
            .mapError { API.Error.moyaError($0) }
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("❌ Request failed with error:", error)
                }
            })
            .eraseToAnyPublisher()
    }
}

extension SuccessTargetType where Self: Moya.TargetType {

    func request() -> AnyPublisher<Void, API.Error> {
        CombineMoyaProviderRequest(self)
            .mapError { API.Error.moyaError($0) }
            .flatMap{ response -> AnyPublisher<Void, API.Error> in
                Future { promise in
                    switch response.statusCode {
                    case 200..<300:
                        promise(.success(()))
                    default:
                        let error = NSError(domain: NSPOSIXErrorDomain, code: response.statusCode)
                        promise(.failure(.error(error)))
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension TargetType {
    
    func rawRequest() -> AnyPublisher<Moya.Response, MoyaError> {
        CombineMoyaProviderRequest(self)
    }
    
}

// MARK: - TargetType Provider caching

private func CombineMoyaProviderRequest<T: TargetType>(_ target: T) -> AnyPublisher<Moya.Response, MoyaError> {
    let provider = MoyaProvider<T>.default()

    if target is IsUnauthorized {
        return provider
            .request(target)
            .handleEvents(receiveCompletion: { _ in
                _ = provider // Keeps strong reference to the provider until completed
            })
            .eraseToAnyPublisher()
    } else {
        fatalError("Not impplemented")
    }
}
