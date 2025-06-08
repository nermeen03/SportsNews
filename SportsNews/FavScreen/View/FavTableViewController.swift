//
//  FavTableViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit
protocol FavViewProtocol{
    func showLeagues()
}
class FavTableViewController: UITableViewController, FavViewProtocol, UISearchBarDelegate {
    var favPresenter: FavPresenterProtocol?
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favPresenter = FavPresenter(favView: self, local: LocalDataSource.shared)
        title = "Favorite".localized
        searchBar.delegate = self
        setupConnectivity()
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        tableView.addSubview(activityIndicator)

        activityIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
        let nib = UINib(nibName: "CellNib", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    deinit {
            stopConnectivity()
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favPresenter?.getLeaguesFromLocal()
        checkSearchBar()
        NotificationCenter.default.addObserver(self,selector: #selector(appWillEnterForeground),name: UIApplication.willEnterForegroundNotification,object: nil)
    }
    
    @objc func appWillEnterForeground() {
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        favPresenter?.filterLocalArray(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        favPresenter?.filterLocalArray(searchText: searchBar.text ?? "")
    }
    
    func checkSearchBar() {
        if favPresenter?.getleaguesBySportCount() ?? 0 == 0 && searchBar.text?.isEmpty ?? true{
            print("niiiilllll")
            searchBar.isHidden = true
            tableView.isUserInteractionEnabled = false
        }else if favPresenter?.getleaguesBySportCount() ?? 0 == 0 {
            print("0000000000")
            searchBar.isHidden = false
            tableView.isUserInteractionEnabled = true
        }else{
            print("11111111111")
            searchBar.isHidden = false
            tableView.isUserInteractionEnabled = true
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return favPresenter?.filteredSortedSports.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sport = favPresenter?.filteredSortedSports[section]else{
            return 0
        }
        return favPresenter?.filteredLeaguesBySport[sport]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let array = favPresenter?.filteredLeaguesBySport else {
            return 0
        }
        if array.count == 0 {
            return tableView.frame.height
        }
        return 120
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let sport = favPresenter?.filteredSortedSports[indexPath.section] else{
            return createEmptyCell()
        }
        guard let leagueItem = favPresenter?.filteredLeaguesBySport[sport]?[indexPath.row] else {
                return createEmptyCell()
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellNib
            cell.customLabel.text = leagueItem.league.leagueName
            cell.favBtn?.isHidden = true

            if let logoURL = URL(string: leagueItem.league.leagueLogo ?? "") {
                cell.customImage.kf.setImage(with: logoURL)
            } else {
                let number = (indexPath.row % 5) + 1
                let imageName = "\(sport.rawValue)\(number)"
                cell.customImage.image = UIImage(named: imageName)
            }

            return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let sport = favPresenter?.filteredSortedSports[indexPath.section] else{
            return
        }
        guard let leagueItem = favPresenter?.filteredLeaguesBySport[sport]?[indexPath.row] else { return }

            if isConnected {
                let storyBoard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
                let details = storyBoard.instantiateViewController(identifier: "leaguesDetailsID") as! LeaguesDetailsProtocol
                details.sportName = leagueItem.sportType
                details.league = leagueItem.league
                navigationController?.pushViewController(details, animated: true)
            } else {
                showAlert(title: "No Internet Connection".localized, message: "Please check your internet connection".localized, view: self)
            }
    }
    
    func showLeagues() {
        self.activityIndicator.stopAnimating()
//        let isEmpty = favPresenter?.isEmpty() ?? true
//        self.tableView.isUserInteractionEnabled = !isEmpty
//        self.tableView.allowsSelection = !isEmpty
//        self.tableView.isScrollEnabled = !isEmpty
        checkSearchBar()
        tableView.reloadData()
    }

    func createEmptyCell() -> UITableViewCell{
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        if traitCollection.userInterfaceStyle == .dark {
            imageView.image = UIImage(named: "noData")
        } else {
            imageView.image = UIImage(named: "noDataDark")
        }

        cell.contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.heightAnchor.constraint(equalToConstant: 180)
        ])

        checkSearchBar()
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let sport = favPresenter?.filteredSortedSports[indexPath.section] else {
                return }
            guard let leagueItem = favPresenter?.filteredLeaguesBySport[sport]?[indexPath.row] else { return }

                    let alert = UIAlertController(title: "Delete League".localized, message: "Are you sure you want to remove this league from your favorites?".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: {[weak self] _ in
                        guard let self = self else { return }

                        self.favPresenter?.deleteLeagueFromLocal(league: leagueItem)
                        self.showLeagues()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
                    present(alert, animated: true)
                }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return favPresenter?.filteredSortedSports[section].rawValue.capitalized
    }
}
