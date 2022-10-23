//
//  BookProductView.swift
//  RentProduct
//

import UIKit

class BookProductView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    var viewModel: HomeViewModel?
    let pickerView = ToolbarPickerView()
    var productForBook = [ProductElement]()
    var selectedProduct : ProductElement?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.prepareDataSet()
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Log.info("Init book product view.")

        self.prepareDataSet()
        self.commonInit()
    }

    private func prepareDataSet() {
        viewModel = HomeViewModel()
        viewModel?.getProductsForBook()
        viewModel?.filteredProducts.bind({ products in
            Log.info("filter return product recieved count - \(products.count)")
            self.productForBook = products
            self.selectedProduct = products.first
        })
    }

    private func commonInit() {
        DispatchQueue.main.async {
            self.containerView.layer.cornerRadius = 15
            self.bgView.backgroundColor = .black.withAlphaComponent(0.3)
            self.setUpPickerView()
            self.setDatePickerMinDate()
        }
    }

    private func setUpPickerView() {
        if let firstProduct = self.productForBook.first {
            self.productTextField.text = "\(firstProduct.code) - \(firstProduct.name)"
        }
        self.productTextField.layer.cornerRadius = 5
        self.productTextField.layer.borderColor = UIColor.darkGray.cgColor
        self.productTextField.layer.borderWidth = 0.5

        self.productTextField.inputView = self.pickerView
        self.productTextField.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.reloadAllComponents()
    }

    private func setDatePickerMinDate() {
        let minDate = Calendar.current.date(byAdding: .day, value: Int(self.selectedProduct?.minimumRentPeriod ?? 0), to: Date())
        self.datePicker.minimumDate = minDate
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        Log.info("Cancel - remove book view.")
        self.removeFromSuperview()
    }

    @IBAction func okButtonPressed(_ sender: UIButton) {
        Log.info("OK - show book confirmation dialog")
        if let curVC = GlobalMethod.getFirstViewController(ofView: self) as? HomeViewController {
            var price: Double = 0
            if let product = self.selectedProduct {
                price = viewModel?.getEstimatedPrice(forProduct: product, till: datePicker.date) ?? 0
            }
            Log.info("Total estimated price - \(price)")
            let alertTitle = "Book a product"
            let alertMessage = "Your estimated price is $\(price).\nDo you want to proceed"
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "No", style: .default))

            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                Log.info("Book product confirmed.")
                self.viewModel?.bookProductForRent(self.selectedProduct)
                curVC.viewModel.getAllProducts()
                self.removeFromSuperview()
            }
            alert.addAction(yesAction)

            curVC.present(alert, animated: true)
        }
    }

    class func instanceFromNib() -> UIView? {
        Log.info("Book instance from nib")
        let nibName = "BookProductView"
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? UIView
    }
}

extension BookProductView: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let productCount = self.productForBook.count
        Log.info("Showing \(productCount) book elements in picker view.")
        return productCount
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let product = self.productForBook[row]
        return "\(product.code) - \(product.name)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let product = self.productForBook[row]
        Log.info("Selected book product code - \(product.code)")
        self.productTextField.text = "\(product.code) - \(product.name)"
        self.selectedProduct = product
        self.setDatePickerMinDate()
    }
}

extension BookProductView: ToolbarPickerViewDelegate {
    func didTapDone() {
        Log.info("Remove picker view.")
        self.productTextField.resignFirstResponder()
    }
}
