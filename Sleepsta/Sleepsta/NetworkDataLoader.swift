//
//  NetworkDataLoader.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/11/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
    func loadData(using url: URL, completion: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkDataLoader {
    
    func loadData(using request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        dataTask(with: request) { (data, _, error) in
            completion(data, error)
            }.resume()
        
    }
    
    func loadData(using url: URL, completion: @escaping (Data?, Error?) -> Void) {
        dataTask(with: url) { (data, _, error) in
            completion(data, error)
            }.resume()
    }
}
