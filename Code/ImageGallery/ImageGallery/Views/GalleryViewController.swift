//
//  GalleryViewController.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
// configure homw many items to display in per row
private enum ItemsPerRow: Int {
    case one = 1
    case two = 2
    case three = 3
}
// configure view type
private enum ViewType {
    case list
    case grid
}
class GalleryViewController: UIViewController {
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    // view model
    private var galleryViewModel: GalleryViewModelProtocol!
    // other internal variables
    private var itemsPerRow: ItemsPerRow = .one {
        didSet {
            // refresh collection when items per row is updated
            self.collectionView.reloadData()
        }
    }
    private let heightForAuthorName: CGFloat = 50
    private let heightForPhotoDescription: CGFloat = 80
    private var sectionInsetsGrid = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private var sectionInsetsList = UIEdgeInsets(top: 20.0, left: 10, bottom: 20.0, right: 10)
    private var viewType: ViewType = .list {
        didSet {
            // update view type and this intern changes items per row
            switch viewType {
            case .list:
                itemsPerRow = .one
                gridOrListToggleButton?.setBackgroundImage(UIImage(named: "grid"), for: .normal)
            case .grid:
                itemsPerRow = .two
                gridOrListToggleButton?.setBackgroundImage(UIImage(named: "list"), for: .normal)
            }
        }
    }
    // button grid/list toggle
    private var gridOrListToggleButton: UIButton?
    // button for sorting option
    private var sortButton: UIButton?
    // selected photo index
    private var selectedPhotoIndex: Int?
    // check if search bar is active
    private var isSearchActive: Bool = false {
        didSet {
            // update ui based on isSearchActive new value
            self.searchBar.showsCancelButton = isSearchActive
            self.navigationController?.setNavigationBarHidden(isSearchActive, animated: false)
            self.collectionView.reloadData()
        }
        
    }
    //MARK:- Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Public photos"
        // setup search bar
        setupSearchBar()
        // setup navigation bar ui
        setupNavigationBar()
        // setup refresh control
        setupRefreshControl()
        // set view model for current view
        setupViewModel()
        // setup collection view
        setupCollectionView()
        // get public photos from view model
        getPublicPhotos()
        // setup default view type
        viewType = .list
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.isSearchActive, animated: false)
        self.collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        // clear cache in case of memory wwarning
        self.galleryViewModel.clearCache()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check if we have a selected index
        if let index = selectedPhotoIndex {
            // check destination identifier
            if segue.identifier == "ShowImageDetail" {
                if let destination = segue.destination as? ImageDetailViewController {
                    // setup view model
                    if isSearchActive {
                        // since search is active setup filtered data
                        destination.imageDetailViewModel = self.galleryViewModel.filteredViewModels[index]
                    } else {
                        // since search is in active set actual data
                        destination.imageDetailViewModel = self.galleryViewModel.imageViewModels[index]
                    }
                }
            }
        }
        // set selected index to nil
        selectedPhotoIndex = nil
    }
    //MARK:- Setup
    /** Setup search bar */
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.accessibilityIdentifier = "Search Bar"
    }
    /** This method is to setup view model for the view */
    private func setupViewModel() {
        if ProcessInfo.processInfo.arguments.contains("USE_MOCK_SERVER") {
            // setup mock comms provider in case we are performing ui tests
            self.galleryViewModel = GalleryViewModel(with: PublicPhotoDataProvider(with: CommsProviderMock(), sortOrder: Constants.defaultSortOrder))
        } else {
            self.galleryViewModel = GalleryViewModel(with: PublicPhotoDataProvider(with: CommsProvider.shared, sortOrder: Constants.defaultSortOrder))
        }
    }
    /** This method is to setup collectionv view */
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    /** This method is setup navigation bar */
    private func setupNavigationBar() {
        // setup grid to list toggle
        if gridOrListToggleButton == nil {
            gridOrListToggleButton = UIButton(type: .custom)
        }
        gridOrListToggleButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        gridOrListToggleButton?.tag = 1
        gridOrListToggleButton?.addTarget(self, action: #selector(toggleBetweenGridAndList), for: .touchUpInside)
        gridOrListToggleButton?.accessibilityIdentifier = "Display type button"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: gridOrListToggleButton!)
        
        // setup sort button
        if sortButton == nil {
            sortButton = UIButton(type: .custom)
        }
        sortButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        sortButton?.tag = 1
        sortButton?.setBackgroundImage(UIImage(named: "sort"), for: .normal)
        sortButton?.addTarget(self, action: #selector(showSortOptions), for: .touchUpInside)
        sortButton?.accessibilityIdentifier = "Sort button"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sortButton!)
        
    }
    /** This method is to cofigure refresh control */
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        collectionView.refreshControl = refreshControl
    }
    //MARK:- Actions
    /** This is the action for grid to list toggle button, which updates the view type */
    @objc func toggleBetweenGridAndList() {
        if self.viewType == .grid {
            self.viewType = .list
        } else {
            self.viewType = .grid
        }
    }
    /** This method is action for sort button, which presents the actionsheet and
     later updates the sort option in the view model, and re-fetches the data from DB
     */
    @objc func showSortOptions() {
        let actionSheet = UIAlertController(title: "Sort by", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Latest published", style: .default) { (action) in
            // date published chronological
            self.galleryViewModel.set(sortOrder: .oldestPublished)
            self.getPublicPhotosFromDb()
        })
        actionSheet.addAction(UIAlertAction(title: "Oldest published", style: .default) { (action) in
            // date published reverse chronological
            self.galleryViewModel.set(sortOrder: .latestPublished)
            self.getPublicPhotosFromDb()
        })
        actionSheet.addAction(UIAlertAction(title: "Latest taken", style: .default) { (action) in
            // date taken chronological
            self.galleryViewModel.set(sortOrder: .oldestTaken)
            self.getPublicPhotosFromDb()
        })
        actionSheet.addAction(UIAlertAction(title: "Oldest taken", style: .default) { (action) in
            // date taken reverse chronological
            self.galleryViewModel.set(sortOrder: .latestTaken)
            self.getPublicPhotosFromDb()
        })
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    /** This is an action for refresh control */
    @objc private func refreshControlValueDidChange() {
        if !isSearchActive {
            self.getPublicPhotos()
        }
    }
}
//MARK:- GalleryViewProtocol implementation
extension GalleryViewController: GalleryViewProtocol {
    // this is an implementation of GalleryViewProtocol, which allows us to get public photos from view model and call api
    func getPublicPhotos() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.beginRefreshing()
        }
        self.galleryViewModel.getAllPublicPhotos { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            if let err = error {
                // see error
                print(err.localizedDescription)
                weakSelf.show(error: error)
            }
            weakSelf.getPublicPhotosFromDb()
        }
    }
    // this is an implementation of GalleryViewProtocol, which allows us to get public photos from db via view model
    func getPublicPhotosFromDb() {
        self.galleryViewModel.getAllPublicPhotosFromDB { [weak self] (success) in
            guard let weakSelf = self else { return }
            if !success {
                // see error
                weakSelf.show(error: NetworkError.noData)
            }
            DispatchQueue.main.async {
                weakSelf.collectionView.refreshControl?.endRefreshing()
                weakSelf.collectionView.reloadData()
            }
        }
    }
    // this is an implementation of GalleryViewProtocol, which allows us to show error to the user
    func show(error: NetworkError?) {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout methods
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isSearchActive ? self.galleryViewModel.filteredViewModels.count : self.galleryViewModel.imageViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublicPhotoCell", for: indexPath) as? PublicPhotoCell else {
            return UICollectionViewCell()
        }
        let imageViewModel = self.isSearchActive ? self.galleryViewModel.filteredViewModels[indexPath.item] : self.galleryViewModel.imageViewModels[indexPath.item]
        // configure cell using view model
        cell.configure(using: imageViewModel)
        cell.delegate = self
        cell.index = indexPath.item + 1
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var paddingSpace: CGFloat = 0
        // calculate padding based on items per row
        switch itemsPerRow {
        case .one:
            paddingSpace = sectionInsetsList.left * (CGFloat(integerLiteral:itemsPerRow.rawValue) + 1)
        default:
            paddingSpace = sectionInsetsGrid.left * (CGFloat(integerLiteral:itemsPerRow.rawValue) + 1)
        }
        // get the width calculated from padding
        let availableWidth = view.frame.width - paddingSpace
        // get width per item
        let widthPerItem = availableWidth / CGFloat(integerLiteral:itemsPerRow.rawValue)
        // get height per item
        let heightPerItem = widthPerItem + heightForAuthorName + heightForPhotoDescription
        // return width and height for the cell
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return section insets fot cells
        switch itemsPerRow {
        case .one:
            return sectionInsetsList
        default:
            return sectionInsetsGrid
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // return line spacing fro cells
        switch itemsPerRow {
        case .one:
            return sectionInsetsList.left
        default:
            return sectionInsetsGrid.left
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotoIndex = indexPath.item
        // preform segue when cell is clicked
        self.performSegue(withIdentifier: "ShowImageDetail", sender: self)
    }
}
//MARK:- UISearchBarDelegate implementation
extension GalleryViewController: UISearchBarDelegate {
    // called when search bar textfield ends editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // update isSearchActive based on its current state
        if let searchText = searchBar.text {
            if searchText.isEmpty {
                isSearchActive = false
                return
            }
        }
        isSearchActive = true
    }
    // called when search bar's textfield begins editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true
    }
    // called when search bar keyboard's search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if !searchText.isEmpty {
                // filter the cities based on search text
                self.galleryViewModel.filter(with: searchText)
                self.collectionView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
    // called when search bar's cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        // reeset filter
        galleryViewModel.resetFilter()
        isSearchActive = false
        
    }
}
//MARK:- PublicPhotoCellDelegate implementations
extension GalleryViewController: PublicPhotoCellDelegate {
    // called when user clicks on share button
    func shareContent(for viewModel: ImageDetailViewModelProtocol?) {
        // create share content
        guard let shareContent = viewModel?.getShareContent() else {
            return
        }
        // share give content
        Utils.shared.share(content: shareContent, from: self)
    }
}
