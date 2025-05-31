//
//  ViewController.swift
//  SportsNews
//
//  Created by mac on 27/05/2025.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let images: [(UIImage,String)] = [
            (UIImage(named: "football")!, "Football"),
            (UIImage(named: "basketball")!, "Basketball"),
            (UIImage(named: "tennis")!, "Tennis"),
            (UIImage(named: "cricket")!, "Cricket")
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CardImageCell", bundle: nil), forCellWithReuseIdentifier: CardImageCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationItem.title = "Sports News"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        let network = NetworkServices()
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = formatter.string(from: todayDate)
        print(today)
        
        let calendar = Calendar.current
        
        guard let futureDate = calendar.date(byAdding: .day, value: 20, to: todayDate) else{return}
        let future = formatter.string(from: futureDate)
        print(future)

        guard let pastDate = calendar.date(byAdding: .day, value: -20, to: todayDate) else{return}
        let past = formatter.string(from: pastDate)
        print(past)
        
        // football, basketball, cricket, tennis
        
//        network.getAllSportLeagues(sportName: "cricket")
        network.getFixtures(sportName: "cricket", leagueKey: 96, fromData: past, toData: today)
        network.getFixtures(sportName: "cricket", leagueKey: 96, fromData: today, toData: future)
        network.getTeamsAndPlayers(sportName: "cricket", leagueId: 96){_ in 
            
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerCollectionContent()
    }
    func centerCollectionContent() {
        guard collectionView.collectionViewLayout is UICollectionViewFlowLayout else { return }

        collectionView.layoutIfNeeded()

        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        let collectionHeight = collectionView.bounds.height

        let inset = max((collectionHeight - contentHeight) / 3, 0)
        collectionView.contentInset.top = inset
//        collectionView.contentInset.bottom = inset
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardImageCell.identifier, for: indexPath) as! CardImageCell
        cell.configure(with: images[indexPath.item].0,and: images[indexPath.item].1)
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemsPerRow: CGFloat = 2
        let spacing: CGFloat = 16
        let totalSpacing = spacing * (itemsPerRow + 1)
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow

        return CGSize(width: width, height: width * 1.3)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

