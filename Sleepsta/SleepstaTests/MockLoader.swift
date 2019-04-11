//
//  MockLoader.swift
//  SleepstaTests
//
//  Created by Dillon McElhinney on 4/11/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
@testable import Sleepsta

class MockLoader: NetworkDataLoader {
    // MARK: - Properties
    let data: Data?
    let error: Error?
    private(set) var request: URLRequest? = nil
    private(set) var url: URL? = nil
    
    // MARK: - Initializers
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    // MARK: - Methods
    func loadData(using url: URL, completion: @escaping (Data?, Error?) -> Void) {
        self.url = url
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            completion(self.data, self.error)
        }
    }
    
    func loadData(using request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        self.request = request
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            completion(self.data, self.error)
        }
    }
}
