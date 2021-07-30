//
//  LocalImage.swift
//  MVVMTemplate

import UIKit
import Combine

@propertyWrapper
struct LocalImage {
    typealias Value = UIImage?
    
    private let url: URL
    private let publisher = CurrentValueSubject<Value, Never>(nil)
    private let fileManager: FileManager
    
    init(
        fileName: String,
        fileManager: FileManager = .default
    ) {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        self.fileManager = fileManager
        url = paths[0].appendingPathComponent(fileName.appending(".png"))
        publisher.send(wrappedValue)
    }

    public var projectedValue: AnyPublisher<Value, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    var wrappedValue: Value {
        get {
            if let data = fileManager.contents(atPath: url.path),
               let value = UIImage(data: data) {
                return value
            }
            return nil
        }
        set {
            do {
                if let data = newValue?.pngData() {
                    try data.write(to: url, options: .atomic)
                } else {
                    try fileManager.removeItem(at: url)
                }
                publisher.send(newValue)
            } catch {
                print("Failed to modify contents")
            }
        }
    }
}
