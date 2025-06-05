//
//  TeamDetailsViewController.swift
//  SportsNews
//
//  Created by mac on 29/05/2025.
//

import UIKit
import Kingfisher
class TeamDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var indicator:UIActivityIndicatorView?
    var team : FootballTeam?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConnectivity()
        let nib = UINib(nibName: "TeamsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "playercell")
        tableView.delegate = self
        tableView.dataSource = self
        teamName.text = team?.teamName
        if let urlString = team?.teamLogo, let url = URL(string: urlString){
            teamLogo.kf.setImage(with: url)
        }
    }
    deinit {
            stopConnectivity()
        }
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return team?.coaches?.count ?? 0
        case 1:
            return team?.players?.filter{$0.playerType == "Goalkeepers"}.count ?? 0
        case 2:
            return team?.players?.filter{$0.playerType == "Defenders"}.count ?? 0
        case 3:
            return team?.players?.filter{$0.playerType == "Midfielders"}.count ?? 0
        case 4:
            return team?.players?.filter{$0.playerType == "Forwards"}.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TeamsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "playercell") as! TeamsTableViewCell
        var player:FootballPlayer?
        switch indexPath.section {
        case 0:
            cell.playerName.text = team?.coaches?[indexPath.item].coachName
            cell.playerImage.image = UIImage(named:"player_placeholder")
            return cell
        case 1:
            player = team?.players?.filter{$0.playerType == "Goalkeepers"}[indexPath.item]
            break
        case 2:
            player = team?.players?.filter{$0.playerType == "Defenders"}[indexPath.item]
            break
        case 3:
            player = team?.players?.filter{$0.playerType == "Midfielders"}[indexPath.item]
            break
        case 4:
            player = team?.players?.filter{$0.playerType == "Forwards"}[indexPath.item]
            break
        default:
            cell.playerName.text = "null"
        }
        var number = player?.playerNumber
        if number == "" {
            number = "99"
        }
        cell.playerName.text = "\(number ?? "99") - \( player?.playerName ?? "nil")"
        if let string = player?.playerImage {
            if let url = URL(string: string){
                cell.playerImage.kf.setImage(with: url,placeholder: UIImage(named: "player_placeholder"))
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Coaches".localized
        case 1:
            return "Goalkeepers".localized
        case 2:
            return "Defenders".localized
        case 3:
            return "Midfielders".localized
        case 4:
            return "Forwards".localized
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
