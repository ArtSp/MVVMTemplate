//
//  User.swift
//  MVVMTemplate

import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    let name: String
    let age: Int
}
