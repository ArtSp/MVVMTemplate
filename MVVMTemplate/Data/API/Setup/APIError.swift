//
//  APIError.swift
//  Created by Artjoms Spole on 03/06/2022.
//

import Moya

extension API {
    /// Wrapper for different error types
    indirect enum Error: LocalizedError {
        typealias Code = Int
        
        case moyaError(MoyaError)
        case error(Code?, Swift.Error)
        
        var errorCode: Code? {
            switch self {
            case let .moyaError(moyaError): return moyaError.response?.statusCode
            case let .error(code, _): return code
            }
        }
        
        var errorDescription: String? {
            switch self {
            case let .moyaError(moyaError):
#if PRODUCTION
                return moyaError.localizedDescription
#else
                if case let .objectMapping(error, _) = moyaError {
                    return [moyaError.localizedDescription, (error as? DecodingError)?.debugDescription]
                        .compactMap { $0 }
                        .joined(separator: "\n")
                } else {
                    return moyaError.localizedDescription
                }
#endif
                
            case let .error(_, error):
                return error.localizedDescription
            }
        }
        
        init?(
            from data: Data
        ) {
            do {
                let errorBody = try JSONDecoder.apiDefault.decode(ErrorBody.self, from: data)
                self = .error(errorBody.errorCode, errorBody.message)
            } catch {
                return nil
            }
        }
        
        private struct ErrorBody: Decodable {
            let errorCode: Code
            let message: String
        }
    }
}
