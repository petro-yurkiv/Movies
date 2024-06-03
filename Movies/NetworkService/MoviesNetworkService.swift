//
//  MoviesNetworkService.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import Foundation

protocol MoviesNetworkServiceProtocol {
    func fetchMovies(category: MovieCategory, page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> Void)
    func getPosterData(posterPath: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class MoviesNetworkService: MoviesNetworkServiceProtocol {
    enum NetworkError: Error {
        case invalidResponse
        case noData
    }
    
    func fetchMovies(category: MovieCategory, page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        let url = URL(string: category.baseURL)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "api_key", value: "d2d7ef3a5f2450215353a9c0ca08ea9d")
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            print("json \(json)")
            self?.handleResponse(completion: completion, data: data, response: response, error: error)
        }
        .resume()
    }
    
    private func getPosterURL(_ posterPath: String) -> URL? {
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "w500"
        return URL(string: baseURL + size + posterPath)
    }
    
    func getPosterData(posterPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = getPosterURL(posterPath) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                self?.handleResponse(completion: completion, data: data, response: response, error: error)
            }
            .resume()
        }
    }
}

private extension MoviesNetworkService {
    func handleResponse(
        completion: @escaping (Result<MoviesResponse, Error>) -> Void,
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
                let result = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(result))
            }
        }
    }
    
    func handleResponse(
        completion: @escaping (Result<Data, Error>) -> Void,
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
        
        completion(.success(data))
    }
}

