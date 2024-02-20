//
//  ViewController.swift
//  test1
//
//  Created by Huy Vu on 2/20/24.
//

import UIKit

struct APIResponse: Codable{
    let total: Int
    let total_pages: Int
    let results: [Result]
}


struct Result: Codable{
    let id: String
    let urls: URLS
}

struct URLS: Codable{
    let full: String
}


class ViewController: UIViewController {
    
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=office&client_id=1vEY3UguPxk44VTgEoyaQJOHwMGNKOOKkQWCxSXmXGU"
    
    
    private var collectionView:UICollectionView?
    
    var results: [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchPhotos()
    }
    
    func fetchPhotos(){
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data , error == nil else{
                return
            }
           
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
//                print(jsonResult.results.count)
                DispatchQueue.main.async {
                    self.results = jsonResult.results
                }
                
            }
            catch {
                print(error)
            }
        }
        

        task.resume()
    }


}

