//
//  FavTableViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit
protocol FavViewProtocol{
    func showLeagues(leagues : [FavLeagueModel])
}
class FavTableViewController: UITableViewController, FavViewProtocol {
    var favLeagues: [FavLeagueModel]?
    var favPresenter: FavPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        favLeagues = []
        favPresenter = FavPresenter(favView: self, local: LocalDataSource.shared)
        title = "Favorite"
        let nib = UINib(nibName: "CellNib", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    override func viewDidAppear(_ animated: Bool) {
        favPresenter?.getLeaguesFromLocal()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favLeagues?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellNib
        cell.customLabel.text = favLeagues?[indexPath.item].league.leagueName
        cell.favBtn.isHidden = true
        if let logoURL = URL(string: favLeagues?[indexPath.item].league.leagueLogo ?? "") {
            cell.customImage.kf.setImage(with: logoURL)
        } else {
            var name : String?
            let number = (indexPath.row % 5) + 1
            switch favLeagues?[indexPath.item].sportType {
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
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
        let details = storyBoard.instantiateViewController(identifier: "leaguesDetails") as! LeaguesDetailsProtocol
        details.sportName = favLeagues?[indexPath.row].sportType
        details.leaguesId = favLeagues?[indexPath.row].league.leagueKey
        navigationController?.pushViewController(details, animated: true)
    }
    
    func showLeagues(leagues: [FavLeagueModel]) {
        favLeagues = leagues
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete League", message: "Are you sure you want to remove this league from your favorites?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
                if let league = self?.favLeagues?[indexPath.row].league {
                    self?.favPresenter?.deleteLeagueFromLocal(league: league)
                    self?.favLeagues?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
