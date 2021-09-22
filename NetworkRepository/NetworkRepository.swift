//
//  NetworkRepository.swift
//  NetworkRepository
//
//  Created by 한상진 on 2021/09/22.
//

import Foundation

public protocol NetworkRepositoryProtocol {
    func request<Model: Decodable>(
        with endpoint: EndpointType, 
        for type: Model.Type,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    )
}

public final class NetworkRepository: NetworkRepositoryProtocol {
    private let session: URLSessionProtocol
    
    public init(with session: URLSessionProtocol) {
        self.session = session
    }
    
    public func request<Model: Decodable>(
        with endpoint: EndpointType, 
        for type: Model.Type,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try endpoint.asURLRequest()    
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            
            guard error == nil else {
                completionHandler(.failure(error!))
                return
            }

            guard 
                let response = response as? HTTPURLResponse,
                200..<300 ~= response.statusCode 
            else {
                completionHandler(.failure(NetworkError.invalidStatus))
                return
            }
            
            guard let model = try? JSONDecoder().decode(Model.self, from: data) else {
                completionHandler(.failure(NetworkError.unableToDecode))
                return
            }

            completionHandler(.success(model))
        }
        
        dataTask.resume()
    }
}
