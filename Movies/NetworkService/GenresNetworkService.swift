//
//  GenresNetworkService.swift
//  Movies
//
//  Created by Petro Yurkiv on 03.06.2024.
//

import Foundation

protocol GenresNetworkServiceProtocol {
    func fetchGenres(completion: @escaping (Result<GenresResponse, Error>) -> Void)
}

final class GenresNetworkService: GenresNetworkServiceProtocol {
    func fetchGenres(completion: @escaping (Result<GenresResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "api_key", value: "d2d7ef3a5f2450215353a9c0ca08ea9d")
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(completion: completion, data: data, response: response, error: error)
        }
        .resume()
    }
}

private extension GenresNetworkService {
    func handleResponse(
        completion: @escaping (Result<GenresResponse, Error>) -> Void,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        guard let data = data, !data.isEmpty else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        Task {
            do {
                let result = try JSONDecoder().decode(GenresResponse.self, from: data)
                completion(.success(result))
            }
        }
    }
}

