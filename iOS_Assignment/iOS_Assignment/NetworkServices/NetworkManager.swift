//
//  NetworkManager.swift
//  iOS_Assignment
//
//  Created by Raghvendra rao on 09/12/19.
//  Copyright © 2019 Raghvendra rao. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() {
    }
    
    func sendRequest(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> (Void)) {
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            if error != nil {
                completion(nil, error)
            } else {
                completion(data, nil)
            }
        })
        
        task.resume()
    }
}
