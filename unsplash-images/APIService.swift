//
//  APIService.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/16.
//

import Foundation


struct APIService {
    struct Config {
        static var authHeaderField: String = "Authorization"
        static var accessKey: String = "Client-ID LcBxNek8tRsRjANLMvdV4t_Xz0Pf1fyBOzXow03G3Ps"
    }
    
    private static var urlRequest: URLRequest? {
        if let url = URL.with(string: "/photos") {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(Config.accessKey, forHTTPHeaderField: Config.authHeaderField)
            return urlRequest
        }
        return nil
    }
    
    static func getList(completion: @escaping (Result<[Image], Error>) -> Void) {
        guard let urlRequest = urlRequest else { return }
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let images = try JSONDecoder().decode([Image].self, from: data)
                    print(images)
                    return completion(.success(images))
                    
                } catch let error {
                    print(error)
                    return completion(.failure(error))
                }
            }
        }.resume()
    }
}


extension URL {
    private static var baseUrl: String {
        return "https://api.unsplash.com"
    }
    
    static func with(string: String) -> URL? {
        return URL(string: "\(baseUrl)\(string)")
    }
}
