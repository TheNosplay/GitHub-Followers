//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import UIKit

protocol UserInfoVCDelegate : class {
    func didReqestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVCViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var headerViewHeight : CGFloat = 90
    
    var username : String!
    weak var delegate : UserInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        configureScrollView()
        getUserInfo()
    }
    
    func configureScrollView(){
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        var contentHeight : CGFloat
        
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed{
            contentHeight = 280 + 69 + 44 + 100
        }else{
            contentHeight = 0
            for itemView in itemViews{
                contentHeight = contentHeight + itemView.frame.height
            }
            contentHeight = contentHeight + 3 * 20
        }

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentHeight)
        ])
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo(){
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
                case .success(let user):
                    DispatchQueue.main.async {
                        self.configureUIElements(with: user)
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    break
            }
        }
    }
    
    func configureUIElements(with user: User){
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since " + user.createdAt.converteToMonthYearFormat()
        
        var contentHeight : CGFloat = 0
        contentHeight =  140*2 + 50 + 80 + headerViewHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    func layoutUI() {
        let padding : CGFloat = 20
        let itemHeight : CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews{
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
    
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
        childVC.view.updateConstraints()
        
        if containerView === headerView{
            containerView.updateConstraints()
            containerView.heightAnchor.constraint(equalToConstant: childVC.preferredContentSize.height).isActive = true
            headerViewHeight = childVC.preferredContentSize.height
        }
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}

extension UserInfoVC : GFRepoItemVCDelegate{
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else{
            presentGFAlertOnMainThread(title: "Invalide URL", message: "The url attaced to this user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}

extension UserInfoVC : GFFollowerVCDelegate{
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else{
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers 😢.", buttonTitle: "So sad")
            return
        }
        guard !user.login.isEmpty else {
            presentGFAlertOnMainThread(title: "Something went wrong", message: GFError.invalidData.rawValue, buttonTitle: "Ok")
        return
        }
        
        delegate.didReqestFollowers(for: user.login)
        dismissVC()
    }
}
