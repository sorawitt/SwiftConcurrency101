//
//  PhotosDataMananger.swift
//  SwiftConcurrency101
//
//  Created by Sorawit Trutsat on 27/7/2565 BE.
//

import Foundation
import UIKit

enum PhotosDataManangerError: Error {
    case badURL
    case httpError
    case otherError
}

class PhotosDataMananger {
    func getRandomImage(completion: @escaping (Result<UIImage, PhotosDataManangerError>) -> Void) {
        guard let url = URL(string: "https://picsum.photos/200") else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                completion(.failure(.httpError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.otherError))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
                return
            } else {
                completion(.failure(.otherError))
                return
            }
        }
        .resume()
    }
    
    func getRandomImageWithAsync() async throws -> UIImage {
        guard let url = URL(string: "https://picsum.photos/200") else {
            throw PhotosDataManangerError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let  response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw PhotosDataManangerError.httpError
        }
        
        if let image = UIImage(data: data) {
            return image
        }
        throw PhotosDataManangerError.otherError
    }
    
    func getRandomImageWithAsync(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw PhotosDataManangerError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let  response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw PhotosDataManangerError.httpError
        }
        
//        try await Task.sleep(nanoseconds: 2_000_000_000)
        if let image = UIImage(data: data) {
            return image
        }
        throw PhotosDataManangerError.otherError
    }
    
    
    // Continuation
    func getCardXImage() {
        BAYThirdParty.shared.getCardImage { result in
            switch result {
            case let .success(image):
                print(image.description)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getCardXImageContinuation() async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            BAYThirdParty.shared.getCardImage { result in
                switch result {
                case let .success(image):
                    continuation.resume(returning: image)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
