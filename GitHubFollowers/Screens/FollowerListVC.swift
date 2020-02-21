//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 17.02.20.
//

import UIKit

class FollowerListVC: GFDataLoadingVCViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers : [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isloadingMoreFollowers = false
    
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>!
    
    init (username: String){
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        showLoadingView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getFollowers(username: String, page : Int){
        isloadingMoreFollowers = true

        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in
            guard let self = self else{return}
 
            switch result{
            case .success(let followers):
                self.updateUI(with: followers)

            case.failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
                print(error.localizedDescription)
            }
            
            self.isloadingMoreFollowers = false
        }
    }
    
    func updateUI(with followers: [Follower]){
        if followers.count < 100 {
            self.hasMoreFollowers = false
            NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
                guard let self = self else {return}
                
                switch result{
                case .success(let user):
                    if user.followers == self.followers.count && !self.hasMoreFollowers{
                        DispatchQueue.main.async {
                            self.dismissLoadingView()
                        }
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
        self.followers.append(contentsOf: followers)
        
        if hasMoreFollowers{
            page += 1
            getFollowers(username: username, page: page)
            self.updateData(on: self.followers)
        }
        if !isloadingMoreFollowers{
            self.updateData(on: self.followers)
        }
        if self.followers.isEmpty{
            let message = "This user doen't have any followers. Go follow them 😉."
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view) }
            return
        }
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result{
            case .success(let user):
                self.addUserToFavourites(user: user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func addUserToFavourites(user: User){
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.update(whit: favourite, actionType: .add) { [weak self] (error) in
            guard let self = self else{ return }
            
            guard let error = error else{
                self.presentGFAlertOnMainThread(title: "Succsess!", message: "You have successfully saved this user🎉!", buttonTitle: "Yay!")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

extension FollowerListVC : UICollectionViewDelegate{
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//
//        if offsetY > contentHeight - height{
//            guard hasMoreFollowers, !isloadingMoreFollowers else{ return }
//            page += 1
//            getFollowers(username: username, page: page)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: W ? T : F
        //What ? Ture : Flase
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
}

extension FollowerListVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else{
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC : UserInfoVCDelegate{
    
    func didReqestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        hasMoreFollowers = true
        isSearching = false
        isloadingMoreFollowers = false
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        updateData(on: followers)
        navigationController?.navigationItem.searchController?.isActive = true
        getFollowers(username: username, page: page)
    }
}
