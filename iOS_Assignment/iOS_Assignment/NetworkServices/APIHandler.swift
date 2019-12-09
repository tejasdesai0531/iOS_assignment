//
//  APIHandler.swift
//  iOS_Assignment
//
//  Created by Raghvendra rao on 09/12/19.
//  Copyright © 2019 Raghvendra rao. All rights reserved.
//

import Foundation

class APIHandler {
    
    static let shared = APIHandler()
    
    private init() {}
    
    func getProductDetails(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> (Void)) {
        
        NetworkManager.shared.sendRequest(url: url) { (data , error) -> (Void) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(data, nil)
            }
        }
    }
}
