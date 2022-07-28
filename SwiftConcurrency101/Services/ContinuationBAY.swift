//
//  PhotosDataManagerWithContinuation.swift
//  SwiftConcurrency101
//
//  Created by Sorawit Trutsat on 27/7/2565 BE.
//

import UIKit

enum BAYError: Error {
    case badURL
    case httpError
    case otherError
}

public class BAYThirdParty {
    public static var shared = BAYThirdParty()
    private init() { }
    
    func getCardImage(completion: @escaping (Result<UIImage, BAYError>) -> Void) {
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
            }
        }
        .resume()
    }
}
