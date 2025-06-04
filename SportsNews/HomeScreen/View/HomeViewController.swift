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
            (UIImage(named: "football")!, "football"),
            (UIImage(named: "basketball")!, "basketball"),
            (UIImage(named: "tennis")!, "tennis"),
            (UIImage(named: "cricket")!, "cricket")
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CardImageCell", bundle: nil), forCellWithReuseIdentifier: CardImageCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        NetworkMonitor.shared.onConnected = {
            showAlert(title: "Online", message: "You're back online ", view: self)
            }

            NetworkMonitor.shared.onDisconnected = {
                showAlert(title: "Offline", message: "No internet connection", view: self)
            }
        
        self.navigationItem.title = "Sports News".localized
//        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkMonitor.shared.checkInternetConnection(completion: {
            [weak self]flag in
            DispatchQueue.main.async {
                if(flag){
                    let storyBoard = UIStoryboard(name: "Leagues", bundle: nil)
                    let details = storyBoard.instantiateViewController(identifier: "leagues") as! LeaguesProtocol
                    switch indexPath.row{
                    case 0:
                        details.sportName = .football
                    case 1:
                        details.sportName = .basketball
                    case 2:
                        details.sportName = .tennis
                    case 3:
                        details.sportName = .cricket
                    default:
                        details.sportName = .football
                    }
                    self?.navigationController?.pushViewController(details, animated: true)
                }else{
                    showAlert(title: "Offline", message: "No internet connection", view: self!)
                }
            }
            
        })
    }
    
}

