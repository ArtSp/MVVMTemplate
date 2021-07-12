//
//  API.swift
//  MVVMTemplate

import Foundation
import Moya
import CombineMoya
import Alamofire
import Combine

enum API {
    static let target = Target()
    
    enum Headers {}
    enum Products {}
    
    /// Wrapper for different error types
    indirect enum Error: Swift.Error {
        case moyaError(MoyaError)
        case error(Swift.Error)
    }
}

extension API {
    static var baseURL: URL { Target.current.baseURL }
}

// MARK: - Default TargetType values

extension Moya.TargetType {
    var baseURL: URL { API.baseURL }
    var sampleData: Data { Data() }
    var validate: Bool { false }
    var headers: [String: String]? { API.Headers.all() }
    var validationType: Moya.ValidationType { .none }
}

// MARK: - Authorized MoyaProvider

extension MoyaProvider {
    
    static func `default`() -> OnlineProvider<Target> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 45
        configuration.timeoutIntervalForResource = 45
        
        let session = Alamofire.Session(configuration: configuration)
        
        return OnlineProvider(
            endpointClosure: { target in
                MoyaProvider.defaultEndpointMapping(for: target)
            },
            requestClosure: { endpoint, closure in
                guard let request = try? endpoint.urlRequest() else {
                    closure(.failure(MoyaError.requestMapping("Failed to generete url in API.swift MoyaProvider extension")))
                    return
                }
                closure(.success(request))
            },
            session: session,
            plugins: [ErrorHandler.shared]
        )
    }
}

// MARK: - OnlineProvider

final class OnlineProvider<Target> where Target: Moya.TargetType {
    
    fileprivate let provider: MoyaProvider<Target>
    
    init(
        endpointClosure: @escaping Moya.MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping Moya.MoyaProvider<Target>.RequestClosure,
        stubClosure: @escaping Moya.MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        session: Moya.Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [Moya.PluginType] = [],
        trackInflights: Bool = false
    ) {
        provider = MoyaProvider(endpointClosure: endpointClosure,
                                requestClosure: requestClosure,
                                stubClosure: stubClosure,
                                callbackQueue: callbackQueue,
                                session: session,
                                plugins: plugins,
                                trackInflights: trackInflights)
    }
    
    func request(
        _ target: Target
    ) -> AnyPublisher<Moya.Response, MoyaError> {
        provider.requestPublisher(target)
    }
}
