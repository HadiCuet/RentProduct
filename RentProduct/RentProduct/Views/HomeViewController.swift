//
//  HomeViewController.swift
//  RentProduct
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!

    private var searchText = ""
    private let tableViewCellName = "ProductTableViewCell"
    let viewModel = HomeViewModel()
    private var products = [ProductElement]()
    private var searchController = UISearchController()
    private var bookProductView : BookProductView?

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info("Home view loaded.")
        self.navigationItem.title = "Rent Product"

        self.setUpTableView()
        self.setUpSearchController()
        self.bindViewModelData()
        self.viewModel.getAllProducts()
    }

    func bindViewModelData() {
        self.viewModel.productElements.bind { [weak self] products in
            guard let `self` = self else { return }
            Log.info("Product received to show - \(products.count)")
            self.products = products
            self.productTableView.reloadData()
        }
    }

    private func setUpTableView() {
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.productTableView.register(UINib(nibName: tableViewCellName, bundle: nil), forCellReuseIdentifier: tableViewCellName)
    }

    private func setUpSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchBar.placeholder = "Search by Product Name"
        self.searchController.searchBar.delegate = self
    }

    @IBAction func bookButtonPressed(_ sender: UIButton) {
        if let bookView = BookProductView.instanceFromNib() as? BookProductView {
            let frameSize = self.view.frame.size
            bookView.frame = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            self.view.addSubview(bookView)
        }
    }

    @IBAction func returnButtonPressed(_ sender: UIButton) {
        if let bookView = ReturnProductView.instanceFromNib() as? ReturnProductView {
            let frameSize = self.view.frame.size
            bookView.frame = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            self.view.addSubview(bookView)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellObject = tableView.dequeueReusableCell(withIdentifier: tableViewCellName, for: indexPath)
        guard let cell = cellObject as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = self.products[indexPath.row]
        cell.setProductData(product)
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchProducts(withString: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.searchText.isEmpty {
            self.viewModel.getAllProducts()
        }
        searchBar.showsCancelButton = false
    }
}



