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

    var containerViewController : UIViewController?
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

        self.prepareDataSet()
        self.commonInit()
    }

    private func prepareDataSet() {
        viewModel = HomeViewModel()
        viewModel?.getProductsForBook()
        viewModel?.filteredProducts.bind({ products in
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
        self.productTextField.text = self.productForBook.first?.name
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
        self.removeFromSuperview()
    }

    @IBAction func okButtonPressed(_ sender: UIButton) {
        if let curVC = GlobalMethod.getFirstViewController(ofView: self) as? HomeViewController {
            var price: Double = 0
            if let product = self.selectedProduct {
                price = viewModel?.getEstimatedPrice(forProduct: product, till: datePicker.date) ?? 0
            }
            let alert = UIAlertController(title: "Return a product", message: "Your estimated price is $\(price).\nDo you want to proceed", preferredStyle: .alert)

            let noAction = UIAlertAction(title: "No", style: .default)
            alert.addAction(noAction)

            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.viewModel?.bookProductForRent(self.selectedProduct)
                curVC.viewModel.getAllProducts()
                self.removeFromSuperview()
            }
            alert.addAction(yesAction)

            curVC.present(alert, animated: true)
        }
    }

    class func instanceFromNib() -> UIView? {
        let nib = UINib(nibName: "BookProductView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? UIView
    }
}

extension BookProductView: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.productForBook.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.productForBook[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.productTextField.text = self.productForBook[row].name
        self.selectedProduct = self.productForBook[row]
        self.setDatePickerMinDate()
    }
}

extension BookProductView: ToolbarPickerViewDelegate {
    func didTapDone() {
        self.productTextField.resignFirstResponder()
    }
}
