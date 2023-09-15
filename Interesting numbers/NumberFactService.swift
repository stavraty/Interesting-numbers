//
//  NumberFactService.swift
//  Interesting numbers
//
//  Created by AS on 13.09.2023.
//
import Foundation

class NumberFactService {
    
    private let baseURL = "http://numbersapi.com/"
    
    func getFact(number: String, type: String, completion: @escaping (Result<String, Error>) -> Void) {
        getFactUsingURL("\(baseURL)\(number)/\(type)", completion: completion)
    }
    
    func getFactInRange(min: String, max: String, completion: @escaping (Result<String, Error>) -> Void) {
        getFactUsingURL("\(baseURL)random?min=\(min)&max=\(max)", completion: completion)
    }
    
    private func getFactUsingURL(_ urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "NumberFactService", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let fact = String(data: data, encoding: .utf8) {
                completion(.success(fact))
            } else {
                completion(.failure(NSError(domain: "NumberFactService", code: 1, userInfo: nil)))
            }
        }.resume()
    }
}


