//
//  ProductDetails.swift
//  iOS_Assignment
//
//  Created by Raghvendra rao on 09/12/19.
//  Copyright © 2019 Raghvendra rao. All rights reserved.
//

import Foundation

struct ProductDetails: Decodable {
    let categories:[ProductCategory]?
    let rankings:[Ranking]?
}

struct ProductCategory: Decodable {
    let id:Int?
    let name:String?
    let products:[Product]?
    let child_categories:[Int]?
    let tax:Tax?
    
    init(id:Int, name:String, prodcuts:[Product], child_categories:[Int], tax:Tax) {
        self.id = id
        self.name = name
        self.products = prodcuts
        self.child_categories = child_categories
        self.tax = tax
    }
}

struct Product: Decodable {
    let id: Int?
    let name: String?
    let date_added:String?
    let variants:[Variant]?
}

struct Tax: Decodable {
    let name: String?
    let value: String?
}

struct Variant: Decodable {
    let id:Int?
    let color:String?
    let size:Int?
    let price:Int?
}

struct Ranking: Decodable {
    let ranking: String?
    let products:[ProductViewCount]?
}

struct ProductViewCount: Decodable {
    let id:Int?
    let view_count:Int?
    let order_count:Int?
    let shares:Int?
}
