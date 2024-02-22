//
//  ImageCollectionViewCell.swift
//  test3
//
//  Created by Huy Vu on 2/21/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self?.img.image = image
                }
            }
        }.resume()
    }

}
