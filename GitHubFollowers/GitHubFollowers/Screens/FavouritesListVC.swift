//
//  FavouritesListVC.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 17.02.20.
//

import UIKit

class FavouritesListVC: GFDataLoadingVCViewController {
    
    let tableView = UITableView()
    var favourites : [Follower] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    func getFavourites() {
        PersistenceManager.retrieveFavourites { [weak self] (result) in
            guard let self = self else { return}
            
            switch result{
            case .success(let favourites):
                self.updateUI(with: favourites)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func updateUI(with favourites: [Follower]){
        if favourites.isEmpty{
            self.showEmptyStateView(with: "No favourites?\nAdd them on the follower screen😛.", in: self.view)
            self.view.bringSubviewToFront(self.view)
        }else{
            self.favourites = favourites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.register(FavouritesCell.self, forCellReuseIdentifier: FavouritesCell.reuseID)
    }
}

extension FavouritesListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesCell.reuseID) as! FavouritesCell
        let favourite = favourites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = UserInfoVC()
        destVC.username = favourite.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        PersistenceManager.update(whit: favourites[indexPath.row], actionType: .remove) { [weak self] (error) in
            guard let self = self else {return}
            guard let error = error else {
                self.favourites.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
                return
            }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
        
        
    }
}

extension FavouritesListVC : UserInfoVCDelegate{
    
    func didReqestFollowers(for username: String) {
        let destVC = FollowerListVC(username: username)
        dismiss(animated: true, completion: nil)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
