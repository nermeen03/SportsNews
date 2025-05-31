//
//  LeaguesDetailsCollectionViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit

protocol LeaguesDetailsProtocol : UIViewController{
    
    var sportName : SportType? { get set }
    var leaguesId : Int? { get set }
    
    func renderUpcomingFixtureToView(fixtureList:[FixtureModel])
    func renderPastFixtureToView(fixtureList:[FixtureModel])
    func renderTeamsToView()
}

class LeaguesDetailsCollectionViewController: UICollectionViewController, LeaguesDetailsProtocol {

    var sportName : SportType?
    var leaguesId : Int?
    
    var pastFixture : [FixtureModel]?
    var upcomingFixture : [FixtureModel]?
    // var teams : [TeamsModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues Details"
        collectionView.register(UINib(nibName: "PrevCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PrevCell")
        collectionView.register(UINib(nibName: "FutureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FutureCell")

        collectionView.register(UINib(nibName: "EmptyCellNib", bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
        
        collectionView.register(UINib(nibName: "LoadingNib", bundle: nil), forCellWithReuseIdentifier: "LoadingCell")


        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
                    switch sectionIndex {
                    case 0 :
                        return self.upcomingEventSection()
                    case 1 :
                        return self.latestEventSection()
                    default:
                        return self.upcomingEventSection()
                    }
                }
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        let presenter = LeaguesDetailsPresenter(leaguesView: self)
        presenter.getDataFromNetwork(sportName: sportName!, leagueId: leaguesId!)
        
    }
    
    func renderUpcomingFixtureToView(fixtureList:[FixtureModel]){
        self.upcomingFixture = fixtureList
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    func renderPastFixtureToView(fixtureList:[FixtureModel]){
        self.pastFixture = fixtureList
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    func renderTeamsToView(){
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func upcomingEventSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(354),
            heightDimension: .absolute(250)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(354),
            heightDimension: .absolute(250)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
        , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
        , bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5
        , bottom: 5, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
             items.forEach { item in
             let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
             let minScale: CGFloat = 0.85
             let maxScale: CGFloat = 1.0
             let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
             item.transform = CGAffineTransform(scaleX: scale, y: scale)
             }
        }
        return section
    }
    
    func latestEventSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(350),
            heightDimension: .absolute(250)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(350),
            heightDimension: .absolute(280)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
        , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10
        , bottom: 0, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 12
        , bottom: 5, trailing: 0)
        return section
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if upcomingFixture == nil  || upcomingFixture!.isEmpty {
                return 1
            } else {
                return upcomingFixture!.count
            }
        case 1:
            if pastFixture == nil || pastFixture!.isEmpty {
                return 1
            } else {
                return pastFixture!.count
            }
        default:
            return 0
        }
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            
            if upcomingFixture == nil {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingNib
                cell.activityIndicator.startAnimating()
                return cell
            } else if upcomingFixture!.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCellNib
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FutureCell", for: indexPath) as? FutureCollectionViewCell else {
                    fatalError("Unable to dequeue FutureCollectionViewCell")
                }
                
                let fixture = self.upcomingFixture![indexPath.row]
                cell.eventDate.text = fixture.fixtureDate + " " + fixture.fixtureTime
                cell.firstName.text = fixture.homeTeam
                cell.secondName.text = fixture.awayTeam
                if let logoURL = URL(string: fixture.homeTeamLogo ?? "") {
                    cell.firstImage.kf.setImage(with: logoURL)
                } else {
                    cell.firstImage.image = UIImage(named: "team_placeholder")
                }
                if let logoURL = URL(string: fixture.awayTeamLogo ?? "") {
                    cell.secondImage.kf.setImage(with: logoURL)
                } else {
                    cell.secondImage.image = UIImage(named: "team_placeholder")
                }
                cell.eventName.text = fixture.leagueName ?? ""
                
                return cell
            }
        case 1:
            if pastFixture == nil {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingNib
                cell.activityIndicator.startAnimating()
                return cell
            } else if pastFixture!.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCellNib
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrevCell", for: indexPath) as? PrevCollectionViewCell else {
                    fatalError("Unable to dequeue PrevCollectionViewCell")
                }
                
                let fixture = self.pastFixture![indexPath.row]
                cell.eventDate.text = fixture.fixtureDate + " " + fixture.fixtureTime
                cell.firstName.text = fixture.homeTeam
                cell.secondName.text = fixture.awayTeam
                if let logoURL = URL(string: fixture.homeTeamLogo ?? "") {
                    cell.firstImage.kf.setImage(with: logoURL)
                } else {
                    cell.firstImage.image = UIImage(named: "team_placeholder")
                }
                if let logoURL = URL(string: fixture.awayTeamLogo ?? "") {
                    cell.secondImage.kf.setImage(with: logoURL)
                } else {
                    cell.secondImage.image = UIImage(named: "team_placeholder")
                }
                cell.eventName.text = fixture.leagueName ?? ""
                cell.eventScore.text = fixture.finalResult ?? "0 - 0"
                
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
