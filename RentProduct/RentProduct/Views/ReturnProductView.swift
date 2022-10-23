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
        Log.info("Init return product view.")

        self.prepareDataSet()
        self.commonInit()
    }

    private func prepareDataSet() {
        viewModel = HomeViewModel()
        viewModel?.getProductsForReturn()
        viewModel?.filteredProducts.bind({ products in
            Log.info("filter product recieved count - \(products.count)")
            self.productsForReturn = products
            self.selectedProduct = products.first
            self.hideShowMileageView()
        })
    }

    private func commonInit() {
        DispatchQueue.main.async {
            self.containerView.layer.cornerRadius = 15
            self.bgView.backgroundColor = .black.withAlphaComponent(0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleBGTap(_:)))
            self.bgView.addGestureRecognizer(tap)

            self.setUpPickerView()
            self.setUpMileageView()
        }
    }

    @objc func handleBGTap(_ sender: UITapGestureRecognizer) {
        if self.mileageTextField.isFirstResponder {
            Log.info("BGTap - hide keyboard")
            self.mileageTextField.resignFirstResponder()
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
        self.mileageTextField.delegate = self
    }

    private func hideShowMileageView() {
        DispatchQueue.main.async {
            self.mileageTextField.text = ""
            if self.selectedProduct?.type == .meter {
                Log.info("Meter type - show mileage input field")
                self.mileageTextField.isHidden = false
                self.containerViewHeightConstraint.constant = 320
            }
            else {
                Log.info("plain type - hide mileage input field")
                self.mileageTextField.isHidden = true
                self.containerViewHeightConstraint.constant = 270
            }
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        Log.info("Cancel - remove return view.")
        self.removeFromSuperview()
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        Log.info("OK - show confirmation dialog")
        if let curVC = GlobalMethod.getFirstViewController(ofView: self) as? HomeViewController {
            var price: Double = 0
            if let product = self.selectedProduct {
                price = viewModel?.getReturnPrice(forProduct: product) ?? product.price
            }
            Log.info("Total price - \(price)")
            let alertTitle = "Return a product"
            let alertMessage = "Your total price is $\(price).\nDo you want to proceed"
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "No", style: .default))

            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                Log.info("Return product confirmed.")
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
        Log.info("Instance from nib")
        let returnNIBName = "ReturnProductView"
        let nib = UINib(nibName: returnNIBName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? UIView
    }
}

extension ReturnProductView: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let productCount = self.productsForReturn.count
        Log.info("Showing \(productCount) elements in picker view.")
        return productCount
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
        Log.info("Selected return product code - \(product.code)")
        self.productTextField.text = "\(product.code) - \(product.name)"
        self.selectedProduct = product
    }
}

extension ReturnProductView: ToolbarPickerViewDelegate {
    func didTapDone() {
        Log.info("Pickview removed.")
        self.productTextField.resignFirstResponder()
        self.hideShowMileageView()
    }
}

extension ReturnProductView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
