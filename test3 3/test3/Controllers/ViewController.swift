//
//  ViewController.swift
//  test3
//
//  Created by Huy Vu on 2/21/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collection_View: UICollectionView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var text: UILabel!
    
    
    
    
    private let viewModel = ImageListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collection_View.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "sdfsdf")
        
        
        let margin: CGFloat = 12
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        var sizeCell = (view.frame.size.width - 3 * margin) / 2 - 2
        if UIDevice.current.userInterfaceIdiom == .pad {
            sizeCell = (view.frame.size.width - 5 * margin) / 4
        }
        
        layout.itemSize = CGSize(width: sizeCell, height: sizeCell)
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        collection_View.collectionViewLayout = layout
        
        // Đăng ký một Gesture Recognizer để bắt sự kiện khi người dùng chạm vào màn hình
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        

        
    }
    
    
    // Hàm để ẩn bàn phím khi người dùng chạm vào màn hình
        @objc func hideKeyboard() {
            view.endEditing(true)
        }

}



extension ViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let count = viewModel.count
            
            // Ẩn img và text nếu không có kết quả và đang không trong quá trình tìm kiếm
            if count == 0 && !viewModel.isSearching {
                img.isHidden = false
                text.isHidden = false
            } else {
                img.isHidden = true
                text.isHidden = true
            }
            
            return count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sdfsdf", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // Kiểm tra nếu không có kết quả
        guard !viewModel.isSearching else {
            return cell // Trả về cell trống khi đang tìm kiếm
           
        }
        
        if let result = viewModel.getResult(at: indexPath.row) {
            cell.configure(with: result.urls.regular)
            
            // Bo góc của ảnh thành hình tròn
                 cell.img.layer.cornerRadius = 16
                 cell.img.clipsToBounds = true
            
        }
        
        
        return cell
    }
    

}


// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            viewModel.fetchPhotos(query: text) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching photos: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.collection_View.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        viewModel.cancelSearch()
        img.isHidden = false
        collection_View.reloadData()
    }
    
}

