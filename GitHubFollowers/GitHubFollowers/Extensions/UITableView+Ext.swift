//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 19.02.20.
//

import UIKit

extension UITableView{
    
    func reloadDataOnMainThread(){
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells(){
        tableFooterView = UIView(frame: .zero)
    }
    
}
