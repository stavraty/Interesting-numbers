//
//  NumberFactService.swift
//  Interesting numbers
//
//  Created by AS on 13.09.2023.
//
import Foundation

public class NumberFactService {
    
    public init() {}
    
    private let baseURL = "http://numbersapi.com/"
    
    public func getFact(number: String, type: String, completion: @escaping (Result<String, Error>) -> Void) {
        getFactUsingURL("\(baseURL)\(number)/\(type)", completion: completion)
    }
    
    public func getFactInRange(min: String, max: String, completion: @escaping (Result<String, Error>) -> Void) {
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
            
            if let data = data, let rawFact = String(data: data, encoding: .utf8) {
                let fact = self.formatFacts(from: rawFact)
                completion(.success(fact))
            } else {
                completion(.failure(NSError(domain: "NumberFactService", code: 1, userInfo: nil)))
            }
        }.resume()
    }
    
    private func formatFacts(from response: String) -> String {
        guard let data = response.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
            return response
        }

        let sortedFacts = json.sorted { (first, second) -> Bool in
            guard let firstKey = Int(first.key), let secondKey = Int(second.key) else {
                return false
            }
            return firstKey < secondKey
        }
        .map { $0.value.replacingOccurrences(of: "\"", with: "") }

        return sortedFacts.joined(separator: "\n\n")
    }
}
