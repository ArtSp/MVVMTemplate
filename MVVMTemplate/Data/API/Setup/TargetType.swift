//
//  TargetType.swift
//  Created by Artjoms Spole on 03/06/2022.
//

import Moya
import CombineMoya
import Combine

typealias TargetMethod = Moya.Method

// MARK: - Protocols

/// `TargetType` with typealias `T: JSONJoy`
protocol ModelTargetType: AppTargetType {
    associatedtype Response: Decodable
}

/// `TargetType` with success type
protocol SuccessTargetType: AppTargetType {}

/// Request does not require authorization
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

extension TargetType {
    var baseURL: URL { API.baseURL }
    var sampleData: Data { Data() }
    var validate: Bool { false }
    var validationType: Moya.ValidationType { .none }
    var decoder: JSONDecoder { .apiDefault(for: self) }
    var encoder: JSONEncoder { .apiDefault(for: self) }
    var headers: [String: String]? {
        API.headers(authToken: self is IsUnauthorized ? nil : API.authToken)
    }
}

protocol AppTargetType: TargetType {
    var method: TargetMethod { get }
    var request: TargetRequest? { get }
    var encoding: URLEncoding? { get }
    var baseURL: URL { get }
}

extension AppTargetType {
    var request: TargetRequest? { nil }
    var encoding: URLEncoding? { nil }
    var baseURL: URL { API.baseURL }
    
    var task: Moya.Task {
        switch request {
        case let .multipart(data): return .uploadMultipart(data)
        case let .parameters(parameters): return .requestParameters(parameters: parameters, encoding: encoding ?? URLEncoding.queryString)
        case let .encodable(encodable): return .requestCustomJSONEncodable(encodable, encoder: encoder)
        case let .data(data): return .requestData(data)
        case .none : return .requestPlain
        }
    }
}

// MARK: - TargetRequest

enum TargetRequest {
    case parameters([String: Any])
    case multipart([MultipartFormData])
    case data(Data)
    case encodable(Encodable)
}

// MARK: - request() methods

extension ModelTargetType {
    
    func fakeRequest(
        delaySeconds: TimeInterval = Constants.simulatedNetworkRequestDelay
    ) -> AnyPublisher <Response, Error> {
        CombineMoyaProviderRequest(self, stubClosure: MoyaProvider.delayedStub(delaySeconds))
            .filterSuccessfulStatusCodes()
            .map(Response.self, using: decoder)
            .mapError { moyaError -> API.Error in
                guard let data = moyaError.response?.data, let error = API.Error(from: data) else {
                    return .moyaError(moyaError)
                }
                return error
            }
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion { print("❌", error) }
            })
            .eraseToAnyPublisher()
    }
    
    func request() -> AnyPublisher<Response, Error> {
        CombineMoyaProviderRequest(self)
            .filterSuccessfulStatusCodes()
            .map(Response.self, using: decoder)
            .mapError { moyaError -> API.Error in
                guard let data = moyaError.response?.data, let error = API.Error(from: data) else {
                    return .moyaError(moyaError)
                }
                return error
            }
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion { print("❌", error) }
            })
            .eraseToAnyPublisher()
    }
}

extension SuccessTargetType {
    
    func fakeRequest(
        delaySeconds: TimeInterval = Constants.simulatedNetworkRequestDelay
    ) -> AnyPublisher<Void, Error> {
        CombineMoyaProviderRequest(self, stubClosure: MoyaProvider.delayedStub(delaySeconds))
            .filterSuccessfulStatusCodes()
            .mapToVoid()
            .mapError { moyaError -> API.Error in
                guard let data = moyaError.response?.data, let error = API.Error(from: data) else {
                    return .moyaError(moyaError)
                }
                return error
            }
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion { print("❌", error) }
            })
            .eraseToAnyPublisher()
    }

    func request() -> AnyPublisher<Void, Error> {
        CombineMoyaProviderRequest(self)
            .filterSuccessfulStatusCodes()
            .mapToVoid()
            .mapError { moyaError -> API.Error in
                guard let data = moyaError.response?.data, let error = API.Error(from: data) else {
                    return .moyaError(moyaError)
                }
                return error
            }
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion { print("❌", error) }
            })
            .eraseToAnyPublisher()
    }
}

extension AppTargetType {
    
    func rawRequest() -> AnyPublisher<Moya.Response, MoyaError> {
        CombineMoyaProviderRequest(self)
    }
    
}

// MARK: - TargetType Provider caching

private func CombineMoyaProviderRequest<T: AppTargetType>(
    _ target: T,
    stubClosure: @escaping (T) -> StubBehavior = MoyaProvider.neverStub
) -> AnyPublisher<Moya.Response, MoyaError> {
    let provider = MoyaProvider<T>.default(stubClosure: stubClosure)

    let tokenPublisher: AnyPublisher<String?, Never> = {
        target is IsUnauthorized ? Just(nil).eraseToAnyPublisher() : API.getToken()
    }()
    
    // will refresh token if needed
    return tokenPublisher
        .flatMap { _ in
            provider
                .request(target)
                .handleEvents(receiveCompletion: { _ in
                    _ = provider // Keeps strong reference to the provider until completed or failed
                })
        }
        .eraseToAnyPublisher()
}
