//
//  FollowerListViewController.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/18/23.
//

import UIKit

class FollowerListViewController: UIViewController {
    
    enum Section{
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureViewController()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) //to show the the "<- Seach" top navigation bar
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID) //FollowerCell from top of class
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false //collectionview won't have a gray overlay
        navigationItem.searchController = searchController
        
    }
    
    func getFollowers(username: String, page: Int){
        showLoadingView() //from Ext.
        
        
//        Task{ //function does not support concurrency, wrap in a Task
//            do {
//                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
//                //updateUI(with: followers)
//                dismissLoadingView()
//            }catch{
//                //handle errors
//                if let gfError = error as? GFError{
//                    presentGFAlert(title: "Test", message: gfError.rawValue, buttonTitle: "Ok")
//                } else{
//                    presentDefaultError()
//                }
//                dismissLoadingView()
//            }
//
//        }
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in //[weak self] is called a Capture List

            guard let self = self else {return} //unwrapping so you don't need to have a "?" on self objects (self?.)
            self.dismissLoadingView()

            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers) //append the followers

                if self.followers.isEmpty { //Check if user doesn't have any followers, if array is empty
                    let message = "This user doesn't have any followers. Go Follow them!😃"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                }
                self.updateData(on: self.followers)

            case.failure(let error):
                print("\(error)")
//                self.presentGFAlertOnMainThread(title: "Test", message: error.rawValue, buttonTitle: "Ok") //need rawValue because our enum is a rawValue Enum.
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>() 
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FollowerListViewController: UICollectionViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height{
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {return}
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) } //$0 represents to follower, check to make sure user login contains the filter, throw into the filers array
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}
