//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import UIKit

protocol GFRepoItemVCDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC : GFItemInfoVC{
    
    weak var delegate: GFRepoItemVCDelegate!
    
    
    init(user: User, delegate: GFRepoItemVCDelegate){
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
    
}
