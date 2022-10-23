//
//  HomeViewController.swift
//  RentProduct
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var noItemView: UIView!

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
            self.noItemView.isHidden = (products.count > 0)
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

    private func showWarningAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Warning!!!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }

    @IBAction func bookButtonPressed(_ sender: UIButton) {
        guard viewModel.getBookProductCount() > 0 else {
            Log.error("No product available to book.")
            self.showWarningAlert(withMessage: "No product available to book.")
            return
        }
        if let bookView = BookProductView.instanceFromNib() as? BookProductView {
            Log.info("Show book sub view.")
            let frameSize = self.view.frame.size
            bookView.frame = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            self.view.addSubview(bookView)
        }
        else {
            Log.error("Can't instantiate book sub view.")
            self.showWarningAlert(withMessage: "Can't instantiate book sub view.")
        }
    }

    @IBAction func returnButtonPressed(_ sender: UIButton) {
        guard viewModel.getReturnProductCount() > 0 else {
            Log.error("No product available to return.")
            self.showWarningAlert(withMessage: "No product available to return.")
            return
        }
        if let bookView = ReturnProductView.instanceFromNib() as? ReturnProductView {
            Log.info("Show return sub view.")
            let frameSize = self.view.frame.size
            bookView.frame = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            self.view.addSubview(bookView)
        }
        else {
            Log.error("Can't instantiate return sub view.")
            self.showWarningAlert(withMessage: "Can't instantiate return sub view.")
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let productCount = self.products.count
        Log.info("Show \(productCount) products in table view.")
        return productCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellObject = tableView.dequeueReusableCell(withIdentifier: tableViewCellName, for: indexPath)
        guard let cell = cellObject as? ProductTableViewCell else {
            Log.error("ProductTableViewCell instance create failed.")
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
        Log.info("Search product with key - \(self.searchText)")
        self.viewModel.searchProducts(withString: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        Log.info("Search key changed - \(self.searchText)")
        if self.searchText.isEmpty {
            self.viewModel.getAllProducts()
        } else {
            self.viewModel.searchProducts(withString: searchText)
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.searchText.isEmpty {
            self.viewModel.getAllProducts()
        }
        searchBar.showsCancelButton = false
    }
}



