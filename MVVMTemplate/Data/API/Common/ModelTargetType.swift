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

/// `TargetType` with typealias `T: JSONJoy` for array response
protocol ModelArrayTargetType: ModelTargetType {}

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

enum TargetRequest {
    case parameters([String: Any])
    case queryParameters([String: String?])
    case multipart([MultipartFormData])
    case data(Data)
    case encodable(Encodable)
}

// MARK: - Request methods

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
    
//    func requestSuccessOrFailure() -> AnyPublisher<SuccessModelOrFailure<Response>, Never> {
//        return MoyaProviderRequest(self)
////            .map(SuccessModelOrFailure<T>.self, using: decoder)
//    }
//
    func request() -> AnyPublisher<Response, MoyaError> {
        return CombineMoyaProviderRequest(self)
            .map(Response.self, using: decoder)
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Request failed with error:", error)
                }
            })
            .eraseToAnyPublisher()
    }
}

extension ModelArrayTargetType where Self: Moya.TargetType {
//
//    func requestSuccessOrFailure() -> RxSwift.Single<SuccessModelOrFailure<T>> {
//        return RxMoyaProviderRequest(self)
//            .map(SuccessModelOrFailure<T>.self, using: decoder)
//    }
//
    func request() -> AnyPublisher<[Response], MoyaError> {
        return CombineMoyaProviderRequest(self)
            .map([Response].self, using: decoder)
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Request failed with error:", error)
                }
            })
            .eraseToAnyPublisher()
    }
}

//extension SuccessTargetType where Self: Moya.TargetType {
//
//    func requestSuccessOrFailure() -> RxSwift.Single<SuccessOrFailure> {
//        return RxMoyaProviderRequest(self).flatMap { response in
//            return Single<SuccessOrFailure>.create { single in
//                if 200...299 ~= response.statusCode {
//                    single(.success(.success))
//                } else {
//                    if let error = try? decoder.decode(ErrorModel.self, from: response.data) {
//                        if let formErrors = error.formErrors, !formErrors.isEmpty {
//                            single(.success(.failure(formErrors)))
//                        } else if let error = error.error {
//                            single(.success(.failure([error])))
//                        } else {
//                            let error = NSError(domain: NSPOSIXErrorDomain, code: response.statusCode)
//                            single(.error(error))
//                        }
//                    } else {
//                        let error = NSError(domain: NSPOSIXErrorDomain, code: response.statusCode)
//                        single(.error(error))
//                    }
//                }
//
//                return Disposables.create()
//            }
//        }
//    }
//
//    func request() -> Single<Void> {
//        return RxMoyaProviderRequest(self).flatMap { response in
//            return Single<Void>.create { single in
//                if 200...299 ~= response.statusCode {
//                    single(.success(()))
//                } else {
//                    let error = NSError(domain: NSPOSIXErrorDomain, code: response.statusCode)
//                    single(.error(error))
//                }
//
//                return Disposables.create()
//            }
//        }
//    }
//
//    func driveRequest() -> Driver<Void> {
//        return request()
//            .asDriverOrEmpty()
//    }
//
//}

extension TargetType {
    
    func rawRequest() -> AnyPublisher<Moya.Response, MoyaError> {
        CombineMoyaProviderRequest(self)
    }
    
}

// MARK: - TargetType Provider caching

private func CombineMoyaProviderRequest<T: TargetType>(_ target: T) -> AnyPublisher<Moya.Response, MoyaError> {
    let provider = MoyaProvider<T>.defaultProvider()

    if target is IsUnauthorized {
        return provider
            .request(target)
            .handleEvents(receiveCompletion: { _ in
                _ = provider // Keeps strong reference to the provider
            })
            .eraseToAnyPublisher()
    } else {
        fatalError("Not impplemented")
    }
}

private extension JSONEncoder.DateEncodingStrategy {
    static var `default`: JSONEncoder.DateEncodingStrategy {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.appDateFormat
        return JSONEncoder.DateEncodingStrategy.formatted(dateFormatter)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static var `default`: JSONDecoder.DateDecodingStrategy {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.appDateFormat
        return JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
    }
}
