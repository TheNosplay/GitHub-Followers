//
//  GFUserInfoHeaderVC.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
    let bioLabel = GFBodyLabel(textAlignment: .left)
    
    //default values, if something goes wrong calculating the height
    let avatarImageViewHeight : CGFloat = 90
    var usernameLabelFrameHeight : CGFloat = 38
    var nameLabelFrameHeight : CGFloat = 20
    var locationLabelFrameHeight : CGFloat = 20
    var bioLabelFrameHeight : CGFloat = 90
    
    let padding : CGFloat = 20
    let textImagePadding : CGFloat = 12

    var user : User!
    
    
    init(user: User){
        super.init(nibName: nil, bundle: nil)
        self.user = user
        updateLabelFrameSizes()
        updatePrefferedFrameSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(avatarImageView, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel)
        configureUIElements()
        layoutUI()
    }
    
    //calculating the preffered size of the view
    override var preferredContentSize: CGSize{
        get{
            let frameHeight = avatarImageViewHeight + textImagePadding + padding + bioLabelFrameHeight
            return CGSize(width: view.frame.width, height: frameHeight)
        }
        set{
            let frameHeight = avatarImageViewHeight + textImagePadding + padding + bioLabelFrameHeight
            super.preferredContentSize = CGSize(width: view.frame.width, height: frameHeight)
        }
    }
    
    func updateLabelFrameSizes(){
        let widthLabelsRight : CGFloat = view.frame.width - padding - avatarImageViewHeight - textImagePadding
        bioLabelFrameHeight = UIHelper.heightForUILabel(text: user.bio ?? "No Bio available", font: UIFont.preferredFont(forTextStyle: .body), width: view.frame.width - 40)
        nameLabelFrameHeight = UIHelper.heightForUILabel(text: user.name ?? "", font: nameLabel.font!, width: widthLabelsRight)
        usernameLabelFrameHeight = UIHelper.heightForUILabel(text: user.login, font: nameLabel.font!, width: widthLabelsRight)
        locationLabelFrameHeight = UIHelper.heightForUILabel(text: user.location ?? "GitHub" , font: nameLabel.font!, width: (widthLabelsRight - 5))
    }
    
    func updatePrefferedFrameSize(){
        preferredContentSize = CGSize(width: view.frame.width, height: avatarImageViewHeight + textImagePadding + padding + bioLabelFrameHeight)
    }
    
    func configureUIElements(){
        avatarImageView.downloadImage(fromURL: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "GitHub"
        bioLabel.text = user.bio ?? "No Bio available"
        bioLabel.numberOfLines = 0
        bioLabelFrameHeight = UIHelper.heightForUILabel(text: user.bio ?? "No Bio available", font: UIFont.preferredFont(forTextStyle: .body), width: view.frame.width - padding * 2)
        
        locationImageView.image = SFSymbols.location
        locationImageView.tintColor = .secondaryLabel
    }
    
    func layoutUI(){
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarImageViewHeight),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarImageViewHeight),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: usernameLabelFrameHeight),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: nameLabelFrameHeight),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: padding),
            locationImageView.heightAnchor.constraint(equalToConstant: padding),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: locationLabelFrameHeight),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: bioLabelFrameHeight)
        ])
    }
    
}
