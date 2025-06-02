//
//  LeaguesDetailsCollectionViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit
import Kingfisher
protocol LeaguesDetailsProtocol : UIViewController{
    
    var sportName : SportType? { get set }
    var leaguesId : Int? { get set }
    var leagueName : String? {get set}
    func renderUpcomingFixtureToView(fixtureList:[FixtureModel])
    func renderPastFixtureToView(fixtureList:[FixtureModel])
    func renderTeamsToView(teams: [FootballTeam])
    func renderPlayersToView(players: [TennisPlayer])
}

class LeaguesDetailsCollectionViewController: UICollectionViewController, LeaguesDetailsProtocol {
    
    var sportName : SportType?
    var leaguesId : Int?
    var leagueName : String?
    var pastFixture : [FixtureModel]?
    var upcomingFixture : [FixtureModel]?
    var footballTeams: [FootballTeam]?
    var tennisPlayers: [TennisPlayer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = leagueName ?? "Leagues Details"
        collectionView.register(UINib(nibName: "PrevCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PrevCell")
        collectionView.register(UINib(nibName: "FutureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FutureCell")

        collectionView.register(UINib(nibName: "EmptyCellNib", bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
        
        collectionView.register(UINib(nibName: "LoadingNib", bundle: nil), forCellWithReuseIdentifier: "LoadingCell")

        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SectionHeader")
        
        collectionView.register(UINib(nibName: "TeamOrPlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "teamOrPlayerCell")
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
                    switch sectionIndex {
                    case 0 :
                        return self.upcomingEventSection()
                    case 1 :
                        return self.latestEventSection()
                    default:
                        return self.teamsSection()
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
    
    
    // MARK: UICollectionViewDataSource
    
    func upcomingEventSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(354),
            heightDimension: .absolute(220)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(354),
            heightDimension: .absolute(220)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
        , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
        , bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5
        , bottom: 5, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(40)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]

        
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
            widthDimension: .absolute(collectionView.frame.width - 40),
            heightDimension: .absolute(220)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(collectionView.frame.width - 40),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
        , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 5, trailing: 10)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(40)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]

        
        return section
    }
    
    func teamsSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(250),
            heightDimension: .absolute(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(170)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
        , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
        , bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5
        , bottom: 5, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(40)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]

        return section
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                              withReuseIdentifier: "SectionHeader",
                                                                              for: indexPath)
            
            // Remove existing subviews (for reuse)
            headerView.subviews.forEach { $0.removeFromSuperview() }

            // Add a UILabel
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: collectionView.bounds.width - 32, height: 40))
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = .label
            label.text = indexPath.section == 0 ? "Upcoming Events" : indexPath.section == 1 ? "Past Events" : "Teams"
            
            headerView.addSubview(label)
            return headerView
        }
        return UICollectionReusableView()
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
        case 2:
            if sportName == .tennis {
                return tennisPlayers?.count ?? 1
            }else{
                return footballTeams?.count ?? 1
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
        case 2:
            if sportName == .tennis {
                if tennisPlayers == nil {
                    let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingNib
                    loadingCell.activityIndicator.startAnimating()
                    return loadingCell
                }
                if tennisPlayers!.isEmpty {
                    let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCellNib
                    return emptyCell
                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamOrPlayerCell", for: indexPath) as! TeamOrPlayerCollectionViewCell
                if let playerLogo = tennisPlayers![indexPath.item].playerLogo, let logoURL = URL(string:playerLogo) {
                    cell.teamOrPlayerImage.kf.setImage(with: logoURL)
                } else {
                    cell.teamOrPlayerImage.image = UIImage(named: "player_placeholder")
                }
                cell.teamOrPlayerLabel.text = tennisPlayers![indexPath.item].playerName
                return cell
            } else {
                if footballTeams == nil {
                    let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingNib
                    loadingCell.activityIndicator.startAnimating()
                    return loadingCell
                }
                if footballTeams!.isEmpty {
                    let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCellNib
                    return emptyCell
                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamOrPlayerCell", for: indexPath) as! TeamOrPlayerCollectionViewCell
                if let logoURL = URL(string: footballTeams![indexPath.item].teamLogo ?? "") {
                    cell.teamOrPlayerImage.kf.setImage(with: logoURL)
                } else {
                    cell.teamOrPlayerImage.image = UIImage(named: "team_placeholder")
                }
                cell.teamOrPlayerLabel.text = footballTeams![indexPath.item].teamName
                return cell
            }

        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 2 && sportName == .football){
            let storyboard = UIStoryboard(name: "TeamDetails", bundle: nil)
            let teamVC = storyboard.instantiateViewController(withIdentifier: "teamDetails") as! TeamDetailsViewController
            teamVC.team = footballTeams?[indexPath.item]
            navigationController?.pushViewController(teamVC, animated: true)
        }
    }
    func renderTeamsToView(teams: [FootballTeam]) {
            self.footballTeams = teams
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 2))
            }
        }
        
        func renderPlayersToView(players: [TennisPlayer]) {
            self.tennisPlayers = players
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 2))
            }
        }
}
