//
//  HomeViewController.swift
//  RentProduct
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!

    let tableViewCellName = "ProductTableViewCell"
    let viewModel = HomeViewModel()
    var products = [ProductElement]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Rent Product"

        self.setUpTableView()
        self.bindViewModelData()
        self.viewModel.getAllProducts()
    }

    func bindViewModelData() {
        self.viewModel.productElements.bind { [weak self] products in
            guard let `self` = self else { return }
            self.products = products
            self.productTableView.reloadData()
        }
    }

    private func setUpTableView() {
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.productTableView.register(UINib(nibName: tableViewCellName, bundle: nil), forCellReuseIdentifier: tableViewCellName)
    }

    @IBAction func bookButtonPressed(_ sender: UIButton) {
    }

    @IBAction func returnButtonPressed(_ sender: UIButton) {
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



