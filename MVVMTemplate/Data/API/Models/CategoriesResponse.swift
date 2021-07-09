//
//  CategoriesResponse.swift
//  MVVMTemplate


import Foundation

struct CategoriesResponse: Decodable {
    let categoryItems: [CategoryItem]
}

extension CategoriesResponse {
    struct CategoryItem: Decodable, Identifiable {
        let banner: [BannerData]?
        let id: String
        let imageUrl: String?
        let link: Link?
        let subcategories: [CategoryItem]?
        let tintColor: String?
        let title: String
        let sadasd: String
    }
    
    struct BannerData: Decodable {
        let imageUrl: String
        let link: Link
        let imageWidth: Int?
        let imageHeight: Int?
        
    }
    
    struct Link: Decodable {
        let title: String
        let uri: String
    }
}
