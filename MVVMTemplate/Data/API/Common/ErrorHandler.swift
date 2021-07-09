//
//  ErrorHandler.swift
//  MVVMTemplate

import Foundation
import Moya
import Alamofire
import UIKit

final class ErrorHandler: PluginType {
    
    static let instance = ErrorHandler()
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        #if DEBUG
        logRequest(request, target: target)
        #endif
        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        logResponse(result, target: target)
        #endif
    }
    
    private func logRequest(_ request: URLRequest, target: TargetType) {
        print("📤 Will send request", request.method?.rawValue ?? "", ":", request.url?.absoluteString ?? "")
        if target is PrintsRequestBody { request.printBody() }
    }
    
    private func logResponse(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        
        case let .success(response):
            let request = response.request
            let requestUrl = request?.url?.absoluteString ?? "-"
            let status = (200..<300) ~= response.statusCode ? "✅" : "⚠️"
            print(status, "Did receive response", result.map { $0.statusCode }, "for request", request?.method?.rawValue ?? "", ":", requestUrl)
            if target is PrintsResponseBody { response.printBody() }
            
        case let .failure(error):
            let request = error.response?.request
            let requestUrl = request?.url?.absoluteString ?? "-"
            let reason = error.failureReason ?? "-"
            print("❌ Request", request?.method?.rawValue ?? "", ":", requestUrl, "failed with reason:", reason)
            if target is PrintsResponseBody { error.response?.printBody() }
        }
    }
}

// MARK: - Debug helpers
    
protocol PrintsRequestBody {}
protocol PrintsResponseBody {}
protocol PrintsBody: PrintsRequestBody & PrintsResponseBody {}

private extension Response {
    /// Prints body serialized to json or string
    func printBody(serialization: Data.Serialization = .json(.utf8)) {
        print(data: data, serialization: serialization)
    }
}

private extension URLRequest {
    /// Prints body serialized to json or string
    func printBody(serialization: Data.Serialization = .json(.utf8)) {
        print(data: httpBody, serialization: serialization)
    }
}

private func print(data: Data?, serialization: Data.Serialization) {
    print("🕵🏻‍♂️ Body:")
    print(data?.toString(serialization: serialization) ?? data?.toString(serialization: .string(.utf8)) ?? "Empty")
}
