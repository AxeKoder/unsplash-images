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
    
    private static func urlList(_ page: Int?, _ per_page: Int?) -> URLRequest? {
        let page = page ?? 0
        let per_page = per_page ?? 15
        if let url = URL.with(string: "/photos?page=\(page)&per_page=\(per_page)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(Config.accessKey, forHTTPHeaderField: Config.authHeaderField)
            return urlRequest
        }
        return nil
    }
    
    static func getList(page: Int?, per_page: Int?, completion: @escaping (Result<[Image], Error>) -> Void) {
        guard let urlRequest = urlList(page, per_page) else { return }
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
