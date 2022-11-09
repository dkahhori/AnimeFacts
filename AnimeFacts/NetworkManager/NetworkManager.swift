//
//  NetworkManager.swift
//  AnimeFacts
//
//  Created by Dilshodi Kahori on 08/11/22.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    enum NetworkError: Error {
        case badRequest
        case forbidden
        case notFound
        case invalidRequest
        case invalidData
        case noData
    }
    
    /// Эта функция для запроса и загрузки картинок с сервера
    func fetchImage(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    /// Эта функция с типом Decodable совершает 'GET' запрос на сервер.
    func fetch<T:Decodable>(_: T.Type, fromURL: String, completionHandler: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: Link.animeURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.noData))
                print(error?.localizedDescription ?? "No Error Occured")
                return
            }
            
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(value))
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    private init () {}
}
