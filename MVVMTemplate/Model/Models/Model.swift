//
//  Model.swift
//  Created by Artjoms Spole on 06/06/2022.
//

import Combine

typealias ID = Int
typealias Price = Float
typealias Count = Int

protocol ToDomainMapping {
    associatedtype DomainType
    func toDomain() throws -> DomainType
}

extension Sequence where Element: ToDomainMapping {
    func toDomain() throws -> [Element.DomainType] {
        try map { try $0.toDomain() }
    }
}
