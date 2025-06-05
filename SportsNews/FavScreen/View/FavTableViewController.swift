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
class FavTableViewController: UITableViewController, FavViewProtocol {
    var favPresenter: FavPresenterProtocol?
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favPresenter = FavPresenter(favView: self, local: LocalDataSource.shared)
        title = "Favorite".localized
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        tableView.addSubview(activityIndicator)

        activityIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
        let nib = UINib(nibName: "CellNib", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favPresenter?.getLeaguesFromLocal()
        tableView.reloadData()
        NotificationCenter.default.addObserver(self,selector: #selector(appWillEnterForeground),name: UIApplication.willEnterForegroundNotification,object: nil)
    }
    
    @objc func appWillEnterForeground() {
        tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        guard (favPresenter?.getLocalArray()) != nil else {
            return 0
        }

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let array = favPresenter?.getLocalArray() else {
            return 0
        }
        
        if array.count == 0 {
            return 1
        }
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let array = favPresenter?.getLocalArray() else {
            return 0
        }
        if array.count == 0 {
            return tableView.frame.height
        }
        return 120
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let array = favPresenter?.getLocalArray(){
            if array.count == 0 {
                return createEmptyCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellNib
            cell.customLabel.text = array[indexPath.item].league.leagueName
            cell.favBtn?.isHidden = true
            if let logoURL = URL(string: array[indexPath.item].league.leagueLogo ?? "") {
                cell.customImage.kf.setImage(with: logoURL)
            } else {
                var name : String?
                let number = (indexPath.row % 5) + 1
                switch array[indexPath.item].sportType {
                case .football:
                    name = "football\(1)"
                case .basketball:
                    name = "basketball\(number)"
                case .cricket:
                    name = "cricket\(number)"
                case .tennis:
                    name = "tennis\(number)"
                }
                cell.customImage.image = UIImage(named: name!)
            }
            return cell
        }else{
            return createEmptyCell()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let array = favPresenter?.getLocalArray() else {
            return
        }
        let storyBoard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
        let details = storyBoard.instantiateViewController(identifier: "leaguesDetailsID") as! LeaguesDetailsProtocol
        details.sportName = array[indexPath.row].sportType
        details.leaguesId = array[indexPath.row].league.leagueKey
        navigationController?.pushViewController(details, animated: true)
    }
    
    func showLeagues() {
        self.activityIndicator.stopAnimating()
        let isEmpty = favPresenter?.getLocalArray()?.isEmpty ?? true
        self.tableView.isUserInteractionEnabled = !isEmpty
        self.tableView.allowsSelection = !isEmpty
        self.tableView.isScrollEnabled = !isEmpty
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

        tableView.isUserInteractionEnabled = false
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete League".localized, message: "Are you sure you want to remove this league from your favorites?".localized, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: {[weak self] _ in
                guard let self = self,
                      let favPresenter = self.favPresenter,
                      let array = favPresenter.getLocalArray()
                else {
                    return
                }

                let league = array[indexPath.row].league
                favPresenter.deleteLeagueFromLocal(league: league)
                
                let newArray = favPresenter.getLocalArray()
                if newArray?.isEmpty ?? true {
                    self.tableView.reloadData()
                } else {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
