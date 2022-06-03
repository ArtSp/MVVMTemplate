//
//  Provider.swift
//  Created by Artjoms Spole on 03/06/2022.
//

import Moya
import Alamofire
import Combine

extension MoyaProvider {
    
    static func `default`(
        timeoutInterval: TimeInterval = 45,
        stubClosure: @escaping (Target) -> Moya.StubBehavior
    ) -> OnlineProvider<Target> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        
        let session = Alamofire.Session(configuration: configuration)
        
        return OnlineProvider(
            endpointClosure: { target in MoyaProvider.defaultEndpointMapping(for: target) },
            requestClosure: { endpoint, closure in
                guard let request = try? endpoint.urlRequest() else {
                    closure(.failure(MoyaError.requestMapping("Failed to generete url in API.swift MoyaProvider extension")))
                    return
                }
                closure(.success(request))
            },
            stubClosure: stubClosure,
            session: session,
            plugins: [ErrorHandler.shared]
        )
    }
}

// MARK: - OnlineProvider

final class OnlineProvider<Target> where Target: TargetType {
    
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
        provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
    
    func request(
        _ target: Target
    ) -> AnyPublisher<Moya.Response, MoyaError> {
        provider.requestPublisher(target)
    }
}
