//
//  CardImageCell.swift
//  SportsNews
//
//  Created by mac on 29/05/2025.
//
import UIKit

class CardImageCell: UICollectionViewCell {
    
    static let identifier = "CardImageCell"
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var protectionLayer: UIView!
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Styling cardView
            cardView.layer.cornerRadius = 16
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
            cardView.layer.shadowRadius = 8
            cardView.layer.masksToBounds = false
            
            // Styling imageView
            imageView.layer.cornerRadius = 16
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            protectionLayer.layer.cornerRadius = 16
            protectionLayer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            protectionLayer.clipsToBounds = true
        }
        
    func configure(with image: UIImage ,and name: String) {
            imageView.image = image
            sportName.text = name
        }

}
