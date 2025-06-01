//
//  CellNib.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit

class CellNib: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var customImage: UIImageView!
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    var favBtnAction : (()->Void)?
    @IBAction func favBtnPressed(_ sender: Any) {
        favBtnAction?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        customImage.clipsToBounds = true
    
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false

        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = false
        cardView.backgroundColor = .lightGray

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 6
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.layer.shadowPath = UIBezierPath(
                   roundedRect: cardView.bounds,
                   cornerRadius: cardView.layer.cornerRadius
               ).cgPath
        
        customImage.layer.cornerRadius = customImage.frame.width / 2
    }
    
}
