//
//  HomeViewController.swift
//  iOS_Assignment
//
//  Created by Raghvendra rao on 09/12/19.
//  Copyright © 2019 Raghvendra rao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var selectCategoryBtn: UIButton!
    @IBOutlet weak var selectSubCategoryBtn: UIButton!
    
    let tableView = UITableView()
    var selectedBtn = UIButton()
    
    var productDetails:ProductDetails?
    var categories = [Int]()
    var subCategories = [Int]()
    var categoryList = [Int:String]()
    var productCategories = [ProductCategory]()
    var options = [Int]()
    var selectedCategoryId:Int?
    var selectedSubCategoryId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProductDetails()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "ListViewCell")
    }
    
    func fetchProductDetails() {
        
        let url = URL(string: "https://stark-spire-93433.herokuapp.com/json")!
        
        APIHandler.shared.getProductDetails(url: url) { (data, error) -> (Void) in
            guard let data = data else { return }
            
            do {
                self.productDetails = try JSONDecoder().decode(ProductDetails.self, from: data)
                
                self.extractTopCategories()
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
    }
    
    func extractTopCategories() {
        var categories = [Int]()
        var childCategories = [Int]()
        
        for category in self.productDetails!.categories! {
            categoryList[category.id!] = category.name!
            categories.append(category.id!)
            if !category.child_categories!.isEmpty {
                childCategories.append(contentsOf: category.child_categories!)
            }
        }
        
        let set1:Set<Int> = Set(categories)
        let set2:Set<Int> = Set(childCategories)
        
        self.categories = Array(set1.subtracting(set2))
        print(self.categories)
    }
    
    func displayOptions(frame: CGRect) {
        tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
        self.view.addSubview(tableView)
        
        tableView.reloadData()
        
        print("inside display options")
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: CGFloat(self.options.count * 50))
        }
    }
    
    func hideDisplayOptions() {
        let frame = selectedBtn.frame
        UIView.animate(withDuration: 0.5) {
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
        }
    }
    
    @IBAction func selectCategoryBtnWasPressed(_ sender: Any) {
        self.options = categories
        selectedBtn = selectCategoryBtn
        displayOptions(frame: selectCategoryBtn.frame)
    }
    
    @IBAction func selectSubCategoryBtnWasPressed(_ sender: Any) {
        guard let selectedCategoryId = self.selectedCategoryId else { return }
        
        for category in productDetails!.categories! {
            if category.id! == selectedCategoryId {
                subCategories = category.child_categories!
            }
        }
        
        options = subCategories
        selectedBtn = selectSubCategoryBtn
        displayOptions(frame: selectSubCategoryBtn.frame)
    }
    @IBAction func displayProductsBtnWasPressed(_ sender: Any) {
        guard let selectedSubCategoryId = self.selectedSubCategoryId else {
            return
        }
        
        var child_categories = [Int]()
        for category in productDetails!.categories! {
            if category.id! == selectedSubCategoryId {
                child_categories = category.child_categories!
            }
        }
        
        print(selectedSubCategoryId)
        print(child_categories)
        
        productCategories = [ProductCategory]()
        for category in productDetails!.categories! {
            if child_categories.contains(category.id!) {
                productCategories.append(category)
            }
        }
        
        DispatchQueue.main.async {
            let listViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            listViewController.productCategories = self.productCategories
            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }
    @IBAction func mostViewedProductsBtnWasPressed(_ sender: Any) {
//        var productIds = [Int]()
//        for productRanking in productDetails!.rankings! {
//            if productRanking.ranking! == "Most Viewed Products" {
//                for viewCount in productRanking.products! {
//                    productIds.append(viewCount.id!)
//                }
//                break
//            }
//        }
//        
//        var filteredCategories = [ProductCategory]()
//        for category in productDetails!.categories! {
//            var filterdProducts = [Product]()
//            for product in category.products! {
//                if productIds.contains(product.id!) {
//                    filterdProducts.append(product)
//                }
//            }
//            print("HI")
//            let newCategory = ProductCategory(id: category.id!, name: category.name!, prodcuts: filterdProducts, child_categories: category.child_categories!, tax: category.tax!)
//            filteredCategories.append(newCategory)
//        }
//        
//        print(filteredCategories)
//        
//        let listViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
//        listViewController.productCategories = filteredCategories
//        self.navigationController?.pushViewController(listViewController, animated: true)
    }
    @IBAction func mostOrderedProductsBtnWasPressed(_ sender: Any) {
        
    }
    @IBAction func mostSharedProducts(_ sender: Any) {
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        
        cell.label.text = self.categoryList[options[indexPath.row]]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBtn.titleLabel?.text = categoryList[options[indexPath.row]]
        if selectedBtn.tag == 0 {
            selectedCategoryId = options[indexPath.row]
            selectSubCategoryBtn.titleLabel?.text = "Select Sub-Category"
            selectedSubCategoryId = nil
        } else if selectedBtn.tag == 1 {
            selectedSubCategoryId = options[indexPath.row]
        }
        hideDisplayOptions()
    }
}
