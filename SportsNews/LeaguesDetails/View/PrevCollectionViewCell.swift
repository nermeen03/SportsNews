//
//  PrevCollectionViewCell.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit

class PrevCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var eventScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstImage.clipsToBounds = true
        secondImage.clipsToBounds = true
        
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false

        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = false

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 6
        
        cardView.backgroundColor = UIColor(named: "AppBackgroundColor")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        firstImage.layer.cornerRadius = firstImage.frame.width / 2
//        secondImage.layer.cornerRadius = secondImage.frame.width / 2
    }

}
