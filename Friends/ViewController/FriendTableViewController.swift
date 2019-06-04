//
//  FriendTableViewController.swift
//  Friends
//
//  Created by VALID on 5/31/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//
import UIKit
import PKHUD

class FriendsTableViewController: UITableViewController {
    
    let viewModel :FriendsTableViewViewModel = FriendsTableViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.getFriends()
    }
    
    func bindViewModel(){
        viewModel.friendCells.bindAndFire() { [weak self] _ in
            self?.tableView?.reloadData()
            
        }
        viewModel.showLoadingHud.bind() { [weak self] visible in
            if self != nil {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self!.view) : PKHUD.sharedHUD.hide()
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension FriendsTableViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friendCells.value.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.friendCells.value[indexPath.row] {
        case .normal(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendTableViewCell else {
                return UITableViewCell()
            }            
            cell.viewModel = viewModel
            return cell
        case .error(let message):
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = message
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = "No data available"
            return cell
        }
    }
}
