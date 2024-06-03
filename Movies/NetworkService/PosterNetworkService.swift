//
//  PosterNetworkService.swift
//  Movies
//
//  Created by Petro Yurkiv on 03.06.2024.
//

import Foundation

protocol PosterNetworkServiceProtocol {
    func getPosterData(posterPath: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class PosterNetworkService: PosterNetworkServiceProtocol {
    enum NetworkError: Error {
        case invalidResponse
        case noData
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

extension PosterNetworkService {
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

