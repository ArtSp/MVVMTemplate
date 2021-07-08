//
//  API.swift
//  MVVMTemplate

import Foundation
import Moya
import CombineMoya
import Alamofire
import Combine

enum API {
    enum Headers {}
    enum Products {}
    static let target = Target()
}

extension API {
    static var baseURL: URL! { Target.current.baseURL }
    static func baseUlrWithAddedQueryParameters(_ parameters: [String: String?]) -> Foundation.URL {
        guard var urlComponents = URLComponents(string: baseURL.absoluteString) else {
            fatalError("Failed to create URL Component from base URL")
        }
        urlComponents.queryItems = []
        parameters.forEach { key, value in
            urlComponents.queryItems!.append(URLQueryItem(name: key, value: value))
        }
        
        return urlComponents.url!
    }
}

// MARK: - Default TargetType values

extension Moya.TargetType {
    var baseURL: URL { API.baseURL }
    var sampleData: Data { Data() }
    var validate: Bool { false }
    var headers: [String: String]? { API.Headers.all() }
    var validationType: Moya.ValidationType { .none }
}

protocol ParametersInURL {}

// MARK: - Authorized MoyaProvider

extension MoyaProvider {
    
    static func defaultProvider() -> OnlineProvider<Target> {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 45
        configuration.timeoutIntervalForResource = 45
        
        let session = Alamofire.Session(configuration: configuration)
        
        return OnlineProvider(endpointClosure: { target in
            return MoyaProvider.defaultEndpointMapping(for: target)
        }, requestClosure: { endpoint, closure in
            guard let request = try? endpoint.urlRequest() else {
                closure(.failure(MoyaError.requestMapping("Failed to generete url in API.swift MoyaProvider extension")))
                return
            }
            closure(.success(request))
        }, session: session, plugins: [/*ErrorHandler.instance*/])
    }
}

final class OnlineProvider<Target> where Target: Moya.TargetType {
    
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping Moya.MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping Moya.MoyaProvider<Target>.RequestClosure,
         stubClosure: @escaping Moya.MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         session: Moya.Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [Moya.PluginType] = [],
         trackInflights: Bool = false) {
        
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     requestClosure: requestClosure,
                                     stubClosure: stubClosure,
                                     callbackQueue: callbackQueue,
                                     session: session,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
    }
    
    func request(_ target: Target) -> AnyPublisher<Moya.Response, MoyaError> {
        provider.requestPublisher(target)
    }
}

