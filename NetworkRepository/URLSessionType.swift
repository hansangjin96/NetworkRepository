//
//  URLSessionType.swift
//  NetworkRepository
//
//  Created by 한상진 on 2021/09/22.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest, 
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
