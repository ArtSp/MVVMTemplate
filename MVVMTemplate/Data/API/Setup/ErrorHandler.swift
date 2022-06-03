//
//  ErrorHandler.swift
//  Created by Artjoms Spole on 03/06/2022.
//
import Moya
import Alamofire

final class ErrorHandler: PluginType {
    typealias UnauthorizedClosure = (Error) -> Void
    
    static let shared = ErrorHandler()
    private static let logLevel: LogLevel = .all
    
    private enum LogLevel {
        /// Print all request/responce bodies
        case all
        /// Prints only request/responce bodies for PrintsRequest and PrintsResponse targets
        case selective
    }
    
    func prepare(
        _ request: URLRequest,
        target: TargetType
    ) -> URLRequest {
        #if DEBUG
        logRequest(request, target: target)
        #endif
        return request
    }

    func didReceive(
        _ result: Result<Response, MoyaError>,
        target: TargetType
    ) {
        #if DEBUG
        logResponse(result, target: target)
        #endif
        
        // In case unauthorized show landing page
        if case let .success(response) = result, response.statusCode == 401 {
            API.unauthorizedClosure(API.Error(from: response.data)?.errorDescription ?? "Unauthorized")
        }
    }
    
    private func logRequest(
        _ request: URLRequest,
        target: TargetType
    ) {
        print("📤 Will send request", request.method?.rawValue ?? "", ":", request.url?.absoluteString ?? "")
        if Self.logLevel == .all || target is PrintsRequestBody {
            print("🏷 Headers:")
            request.allHTTPHeaderFields?.keys.sorted().forEach { key in
                print(key, ":", request.allHTTPHeaderFields?[key] ?? "" )
            }
            request.printBody()
        }
    }
    
    private func logResponse(
        _ result: Result<Response, MoyaError>,
        target: TargetType
    ) {
        switch result {
        
        case let .success(response):
            let request = response.request
            let requestUrl = request?.url?.absoluteString ?? "-"
            let status = (200..<300) ~= response.statusCode ? "✅" : "⚠️"
            print(status, "Did receive response", response.statusCode, "for request", request?.method?.rawValue ?? "", ":", requestUrl)
            if Self.logLevel == .all || target is PrintsResponseBody { response.printBody() }
            
        case let .failure(error):
            let request = error.response?.request
            let requestUrl = request?.url?.absoluteString ?? "-"
            let reason = error.failureReason ?? "-"
            print("❌ Request", request?.method?.rawValue ?? "", ":", requestUrl, "failed with reason:", reason)
            if Self.logLevel == .all || target is PrintsResponseBody { error.response?.printBody() }
        }
    }
}

// MARK: - Debug helpers
    
protocol PrintsRequestBody {}
protocol PrintsResponseBody {}
protocol PrintsBody: PrintsRequestBody & PrintsResponseBody {}

fileprivate extension Response {
    /// Prints body serialized to json or string
    func printBody(
        serialization: Data.Serialization = .json(.utf8)
    ) {
        print(data: data, serialization: serialization)
    }
}

fileprivate extension URLRequest {
    /// Prints body serialized to json or string
    func printBody(
        serialization: Data.Serialization = .json(.utf8)
    ) {
        print(data: httpBody, serialization: serialization)
    }
}

private func print(
    data: Data?,
    serialization: Data.Serialization
) {
    print("🕵🏻‍♂️ Body:")
    print(
        data?.toString(serialization: serialization) ??
        data?.toString(serialization: .string(.utf8)) ??
        "Empty"
    )
}
