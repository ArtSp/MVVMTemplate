//
//  LocalStorageService.swift
//  MVVMTemplate

import UIKit
import Combine

// MARK: - LocalStorageService

protocol LocalStorageService: AnyObject {
    func setProfileImage(_ image: UIImage?)
    func getProfileImage() -> AnyPublisher<UIImage?, Never>
}

// MARK: - LocalStorageServiceImpl

final class LocalStorageServiceImpl: LocalStorageService {

    @LocalImage(fileName: "profileImage")
    var profileImage: UIImage?
    
    func setProfileImage(_ image: UIImage?) {
        profileImage = image
    }
    
    func getProfileImage() -> AnyPublisher<UIImage?, Never> {
        $profileImage.eraseToAnyPublisher()
    }
    
}

// MARK: - LocalStorageServiceFake

typealias LocalStorageServiceFake = LocalStorageServiceImpl
