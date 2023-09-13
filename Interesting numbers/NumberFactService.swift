//
//  NumberFactService.swift
//  Interesting numbers
//
//  Created by AS on 13.09.2023.
//

import Foundation

class NumberFactService {
    
    // Базовий URL для API
    private let baseURL = "http://numbersapi.com/"
    
    // Функція для отримання цікавого факту за числом і типом
    func getFact(number: String, type: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Складаємо URL для запиту
        let url = URL(string: "\(baseURL)\(number)/\(type)")!
        
        // Виконуємо запит до API
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let fact = String(data: data, encoding: .utf8) {
                completion(.success(fact))
            } else {
                completion(.failure(NSError(domain: "NumberFactService", code: 0, userInfo: nil)))
            }
        }.resume()
    }
}

