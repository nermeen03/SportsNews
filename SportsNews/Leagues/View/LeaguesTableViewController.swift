//
//  LeaguesTableViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import UIKit

protocol LeaguesProtocol : UIViewController {
    func showLeagues(leagues : [LeagueModel])
    var sportName : SportType! { get set }
}

class LeaguesTableViewController: UITableViewController, LeaguesProtocol {
    
    var sportName : SportType!
    var leagues : [LeagueModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Leagues"
        
        let nib = UINib(nibName: "CellNib", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        let presenter = LeaguesPresenter(leaguesView: self)
        presenter.getLeaguesFromNetwork(sportName: sportName)
        
    }
    
    func showLeagues(leagues : [LeagueModel]){
        print(leagues)
        self.leagues = leagues
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leagues.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellNib
        let data = self.leagues[indexPath.row]
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
        let details = storyBoard.instantiateViewController(identifier: "leaguesDetails") as! LeaguesDetailsProtocol
        details.sportName = self.sportName
        details.leaguesId = self.leagues[indexPath.row].leagueKey
        navigationController?.pushViewController(details, animated: true)
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
