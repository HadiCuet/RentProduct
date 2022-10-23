//
//  ReturnProductView.swift
//  RentProduct
//

import UIKit

class ReturnProductView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var repairSwitch: UISwitch!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!

    let pickerView = ToolbarPickerView()
    var productsForReturn = [ProductElement]()
    var selectedProduct : ProductElement?
    var viewModel: HomeViewModel?

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
        viewModel?.getProductsForReturn()
        viewModel?.filteredProducts.bind({ products in
            self.productsForReturn = products
            self.selectedProduct = products.first
            self.hideShowMileageView()
        })
    }

    private func commonInit() {
        DispatchQueue.main.async {
            self.containerView.layer.cornerRadius = 15
            self.bgView.backgroundColor = .black.withAlphaComponent(0.3)
            self.setUpPickerView()
            self.setUpMileageView()
        }
    }

    private func setUpPickerView() {
        if let firstProduct = self.productsForReturn.first {
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

    private func setUpMileageView() {
        self.mileageTextField.keyboardType = .numberPad
    }

    private func hideShowMileageView() {
        DispatchQueue.main.async {
            if self.selectedProduct?.type == .meter {
                self.mileageTextField.isHidden = false
                self.containerViewHeightConstraint.constant = 320
            }
            else {
                self.mileageTextField.isHidden = true
                self.containerViewHeightConstraint.constant = 270
            }
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        if let curVC = GlobalMethod.getFirstViewController(ofView: self) as? HomeViewController {
            var price: Double = 0
            if let product = self.selectedProduct {
                price = viewModel?.getReturnPrice(forProduct: product) ?? product.price
            }
            let alert = UIAlertController(title: "Return a product", message: "Your total price is $\(price).\nDo you want to proceed", preferredStyle: .alert)

            let noAction = UIAlertAction(title: "No", style: .default)
            alert.addAction(noAction)

            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                let mileageNumber = Int64(self.mileageTextField.text ?? "") ?? nil
                self.viewModel?.returnProduct(self.selectedProduct, mileage: mileageNumber, needToRepair: self.repairSwitch.isOn)
                curVC.viewModel.getAllProducts()
                self.removeFromSuperview()
            }
            alert.addAction(yesAction)

            curVC.present(alert, animated: true)
        }
    }

    class func instanceFromNib() -> UIView? {
        let nib = UINib(nibName: "ReturnProductView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? UIView
    }
}

extension ReturnProductView: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.productsForReturn.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let product = self.productsForReturn[row]
        return "\(product.code) - \(product.name)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let product = self.productsForReturn[row]
        self.productTextField.text = "\(product.code) - \(product.name)"
        self.selectedProduct = product
    }
}

extension ReturnProductView: ToolbarPickerViewDelegate {
    func didTapDone() {
        self.productTextField.resignFirstResponder()
        self.hideShowMileageView()
    }
}
