//
//  ImageListViewModel.swift
//  test3
//
//  Created by Huy Vu on 2/22/24.
//

import Foundation

class ImageListViewModel {
    private var results: [Result] = []
    var isSearching: Bool = false // Biến này chỉ ra trạng thái tìm kiếm
    
    var count: Int {
        return results.count
    }
    
    func getResult(at index: Int) -> Result? {
        guard index >= 0, index < results.count else {
            return nil
        }
        return results[index]
    }
    
    func fetchPhotos(query: String, completion: @escaping (Error?) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=150&query=\(query)&client_id=1vEY3UguPxk44VTgEoyaQJOHwMGNKOOKkQWCxSXmXGU"
        
        guard let url = URL(string: urlString) else {
            completion(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        // Thực hiện tải dữ liệu trong luồng nền
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                guard let data = data, error == nil else {
                    completion(error)
                    return
                }
                
                do {
                    let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                    self.results = jsonResult.results
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
            task.resume()
        }
    }
    
    func cancelSearch() {
        URLSession.shared.invalidateAndCancel()
        isSearching = false // Đặt trạng thái tìm kiếm về false khi hủy bỏ
        results.removeAll() // Xóa kết quả hiện có
    }

}
