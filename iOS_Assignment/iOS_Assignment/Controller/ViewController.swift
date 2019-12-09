//
//  ViewController.swift
//  iOS_Assignment
//
//  Created by Raghvendra rao on 09/12/19.
//  Copyright © 2019 Raghvendra rao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var productDetails:ProductDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://stark-spire-93433.herokuapp.com/json")!
        
        APIHandler.shared.getProductDetails(url: url) { (data, error) -> (Void) in
            guard let data = data else { return }
            
            do {
                self.productDetails = try JSONDecoder().decode(ProductDetails.self, from: data)
                
                let categories = self.productDetails?.categories
                
                for category in categories! {
                    if category.child_categories != nil {
                        print("\(category.id!) -  \(category.child_categories!)")
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    


}

