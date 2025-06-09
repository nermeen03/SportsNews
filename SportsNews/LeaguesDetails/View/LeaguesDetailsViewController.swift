//
//  LeaguesDetailsViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 04/06/2025.
//

import UIKit

class LeaguesDetailsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LeaguesDetailsProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sportName : SportType?
    var secondName: String?
    var league : LeagueModel?
    var pastFixture : [FixtureModel]?
    var upcomingFixture : [FixtureModel]?
    var footballTeams: [FootballTeam]?
    var tennisPlayers: [TennisPlayer]?
    var presenter: LeaguesDetailsPresenterProtocol?
    var rightBarButton : UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConnectivity()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        title = league?.leagueName ?? "Leagues Details".localized

        collectionView.register(UINib(nibName: "PrevCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PrevCell")
        collectionView.register(UINib(nibName: "FutureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FutureCell")
        collectionView.register(UINib(nibName: "TeamOrPlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "teamOrPlayerCell")
        collectionView.register(UINib(nibName: "SectionHeaderView", bundle: nil),forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(UINib(nibName: "EmptyCellNib", bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
        
        collectionView.register(UINib(nibName: "LoadingNib", bundle: nil), forCellWithReuseIdentifier: "LoadingCell")
        
        presenter = LeaguesDetailsPresenter(leaguesView: self)
        presenter?.getDataFromNetwork(sportName: sportName!, leagueId: league?.leagueKey ?? 152)
        
        rightBarButton = UIBarButtonItem(
            image: league?.isFav ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapNavBarButton)
            )
            navigationItem.rightBarButtonItem = rightBarButton
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let leagueKey = league?.leagueKey else{
            return
        }
//        print(presenter?.checkFav(leagueID: leagueKey))
        if presenter?.checkFav(leagueID: leagueKey) == true{
            rightBarButton?.image = UIImage(systemName: "heart.fill")
            league?.isFav = true
        }else{
            rightBarButton?.image = UIImage(systemName: "heart")
            league?.isFav = false
        }
    }
    
    deinit {
        stopConnectivity()
        NotificationCenter.default.removeObserver(self)
    }
    @objc func didTapNavBarButton() {
        if var league = league {
            league.isFav?.toggle()
            self.league = league  
            if league.isFav ?? false {
                if let sportName = sportName {
                    rightBarButton?.image = UIImage(systemName: "heart.fill")
                    presenter?.saveLeagueToLocal(league: league, sportName: sportName,secondName: secondName ?? "")
                }
            } else {
                let alert = UIAlertController(
                    title: "Delete League".localized,
                    message: "Are you sure you want to remove this league from your favorites?".localized,
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { [weak self] _ in
                    guard let self = self else { return }
                    DispatchQueue.main.async {[weak self] in
                        self?.rightBarButton?.image = UIImage(systemName: "heart")
                    }
                    self.presenter?.deleteLeagueFromLocal(league: league)
                }))
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    func renderUpcomingFixtureToView(fixtureList:[FixtureModel]){
        self.upcomingFixture = fixtureList
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func renderPastFixtureToView(fixtureList:[FixtureModel]){
        self.pastFixture = fixtureList
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func renderTeamsToView(teams: [FootballTeam]) {
            self.footballTeams = teams
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    func renderPlayersToView(players: [TennisPlayer]) {
        self.tennisPlayers = players
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            switch section {
            case 0:
                return self.upcomingEventSection()
            case 1:
                return self.latestEventSection()
            default:
                return self.teamsSection()
            }
        }
    }
    
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
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(170)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .absolute(170)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
        , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8
        , bottom: 0, trailing: 8)

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


    func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                cell.eventDate.text = fixture.fixtureDate.localizedDigits() + " " + fixture.fixtureTime.localizedDigits()
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
                cell.eventDate.text = fixture.fixtureDate.localizedDigits() + " " + fixture.fixtureTime.localizedDigits()
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
                cell.eventScore.text = fixture.finalResult?.localizedDigits() ?? "0 - 0".localizedDigits()
                
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 2 && sportName == .football){
            if isConnected{
                let storyboard = UIStoryboard(name: "TeamDetails", bundle: nil)
                let teamVC = storyboard.instantiateViewController(withIdentifier: "teamDetails") as! TeamDetailsViewController
                teamVC.team = footballTeams?[indexPath.item]
                navigationController?.pushViewController(teamVC, animated: true)
            }else{
                showAlert(title: "No Internet Connection".localized, message: "Please check your internet connection".localized, view: self)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeaderView",
            for: indexPath) as! SectionHeaderView

        switch indexPath.section {
        case 0: header.titleLabel.text = "Upcoming Events".localized
        case 1: header.titleLabel.text = "Previous Events".localized
        case 2: header.titleLabel.text = "Teams".localized
        default: header.titleLabel.text = ""
        }

        return header
    }


}
