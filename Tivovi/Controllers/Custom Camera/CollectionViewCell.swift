

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
    }
}



