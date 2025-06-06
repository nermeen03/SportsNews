//
//  LeaguesTableViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit

protocol LeaguesProtocol : UIViewController {
    
    var sportName : SportType! { get set }
    func showLeagues()
}

class LeaguesTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, LeaguesProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var sportName : SportType!
    var presenter: LeaguesPresenterProtocol?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.placeholder = "Search Leagues"
        setupConnectivity()
        title = isEnglish() ? "\(sportName.rawValue.localized) \("Leagues".localized)" : "\("Leagues".localized) \(sportName.rawValue.localized)" 
        
        let nib = UINib(nibName: "CellNib", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        presenter = LeaguesPresenter(leaguesView: self)
        presenter?.getLeaguesFromNetwork(sportName: sportName)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        tableView.addSubview(activityIndicator)

        activityIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
        
    }
    deinit {
            stopConnectivity()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
        presenter?.checkFav(sportName: sportName, leagueList: presenter?.getLeagues() ?? [])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.cancelApiCallings()
    }

    
    func showLeagues(){
        tableView.reloadData()
        if (self.presenter?.getLeagues().count ?? 0 > 0){
            self.activityIndicator.stopAnimating()
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.isFiltering ?? false ?
        self.presenter?.filteredLeagues.count ?? 0 :
        self.presenter?.getLeagues().count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellNib
        var leagues = (presenter?.isFiltering ?? false) ? presenter?.filteredLeagues : presenter?.getLeagues()
        if var data = leagues?[indexPath.row] {
            if let logoURL = URL(string: data.leagueLogo ?? "") {
                cell.customImage.kf.setImage(with: logoURL)
            } else {
                var name : String?
                let number = (indexPath.row % 5) + 1
                switch sportName {
                case .football:
                    name = "football\(1)"
                case .basketball:
                    name = "basketball\(number)"
                case .cricket:
                    name = "cricket\(number)"
                case .tennis:
                    name = "tennis\(number)"
                default:
                    name = "football\(1)"
                }
                cell.customImage.image = UIImage(named: name!)
            }
            cell.customLabel.text = data.leagueName
            
            if data.isFav ?? false {
                cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
            cell.favBtnAction = {
                [weak self] in
                guard let self = self else { return }
                
                data.isFav = !(data.isFav ?? false)
                
                if data.isFav == true {
                    presenter?.saveLeagueToLocal(league: data, sportName: self.sportName)
                    leagues?[indexPath.row].isFav = data.isFav
//                    tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Delete League".localized, message: "Are you sure you want to remove this league from your favorites?".localized, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: {[weak self] _ in
                        guard let self = self
                        else {
                            return
                        }
                        presenter?.deleteLeagueFromLocal(league: data)
                        leagues?[indexPath.row].isFav = data.isFav
                        tableView.reloadData()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isConnected{
            let storyBoard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
            let details = storyBoard.instantiateViewController(identifier: "leaguesDetailsID") as! LeaguesDetailsProtocol
            details.sportName = self.sportName
            details.league = self.presenter?.getLeagues()[indexPath.row]
            navigationController?.pushViewController(details, animated: true)
        }else{
            showAlert(title: "No Internet Connection".localized, message: "Please check your internet connection".localized, view: self)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        presenter?.filterLeagues(with: trimmedText)
    }
}
