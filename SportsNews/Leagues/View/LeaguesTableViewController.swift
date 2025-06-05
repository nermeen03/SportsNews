//
//  LeaguesTableViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit

protocol LeaguesProtocol : UIViewController {
    func showLeagues()
    var sportName : SportType! { get set }
}

class LeaguesTableViewController: UITableViewController, LeaguesProtocol {
    
    var sportName : SportType!
    var presenter: LeaguesPresenterProtocol?
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.getLeagues().count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellNib
        if var data = self.presenter?.getLeagues()[indexPath.row]{
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
                    tableView.reloadData()
                } else {
                    presenter?.deleteLeagueFromLocal(league: data)
                    tableView.reloadData()
                }
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isConnected{
            let storyBoard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
            let details = storyBoard.instantiateViewController(identifier: "leaguesDetailsID") as! LeaguesDetailsProtocol
            details.sportName = self.sportName
            details.leaguesId = self.presenter?.getLeagues()[indexPath.row].leagueKey
            details.leagueName = self.presenter?.getLeagues()[indexPath.row].leagueName
            navigationController?.pushViewController(details, animated: true)
        }else{
            showAlert(title: "No Internet Connection", message: "Please check your internet connection", view: self)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
