//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import UIKit

protocol GFFollowerVCDelegate: class {
    func didTapGetFollowers(for user: User)
}

class GFFollowerVC : GFItemInfoVC{
    
    weak var delegate: GFFollowerVCDelegate!
    
    
    init(user: User, delegate: GFFollowerVCDelegate){
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
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
    
}
