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
    
    private static func stringToURLRequest(sub: String) -> URLRequest? {
        if let url = URL.with(string: sub) {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(Config.accessKey, forHTTPHeaderField: Config.authHeaderField)
            return urlRequest
        }
        return nil
    }
    
    private static func urlList(_ page: Int?, _ per_page: Int?) -> URLRequest? {
        let page = page ?? 1
        let per_page = per_page ?? 15
        return stringToURLRequest(sub: "/photos?page=\(page)&per_page=\(per_page)")
    }
    
    private static func urlSearch(_ page: Int?, _ per_page: Int?, query: String) -> URLRequest? {
        let page = page ?? 1
        let per_page = per_page ?? 15
        return stringToURLRequest(sub: "/search/photos?query=\(query)&page=\(page)&per_page=\(per_page)")
    }
    
    private static func dataTask<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    print(response)
                    return completion(.success(response))
                    
                } catch let error {
                    print(error)
                    return completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func getList(page: Int?, per_page: Int?, completion: @escaping (Result<[Image], Error>) -> Void) {
        guard let urlRequest = urlList(page, per_page) else { return }
        print("requesting url = \(urlRequest.url?.absoluteString ?? "")")
        dataTask(urlRequest: urlRequest, completion: completion)
    }
    
    static func getSearch(page: Int?, per_page: Int?, query: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        guard let urlRequest = urlSearch(page, per_page, query: query) else { return }
        dataTask(urlRequest: urlRequest, completion: completion)
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
