//
//  Category.swift
//  MVVMTemplate

import Foundation

struct Category: Identifiable, Codable {
    var id = UUID()
    let name: String
    let items: Int
}
