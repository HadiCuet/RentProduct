//
//  HomeViewModelTest.swift
//  RentProductTests
//

import XCTest
@testable import RentProduct

final class HomeViewModelTest: XCTestCase {

    var viewModel: HomeViewModel?
    var isFirstBind: Bool = true

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
        isFirstBind = true
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testGetAllProducts() {
        viewModel?.productElements.bind({ products in
            if self.isFirstBind {
                XCTAssertEqual(products.count, 0)
                self.isFirstBind = false
            }
            else {
                XCTAssertEqual(products.count, 17)
            }
        })
        viewModel?.getAllProducts()
    }

    func testSearchProductWithStringAir() {
        viewModel?.productElements.bind({ products in
            if self.isFirstBind {
                XCTAssertEqual(products.count, 0)
                self.isFirstBind = false
            }
            else {
                XCTAssertEqual(products.count, 2)
            }
        })
        viewModel?.searchProducts(withString: "Air")
    }

    func testSearchProductWithStringLift() {
        viewModel?.productElements.bind({ products in
            if self.isFirstBind {
                XCTAssertEqual(products.count, 0)
                self.isFirstBind = false
            }
            else {
                XCTAssertEqual(products.count, 8)
            }
        })
        viewModel?.searchProducts(withString: "Lift")
    }

    func testSearchProductWithNotMatchingString() {
        viewModel?.productElements.bind({ products in
            XCTAssertEqual(products.count, 0)
        })
        viewModel?.searchProducts(withString: "RentMe")
    }

    func testGetBookProductCount() {
        let count = viewModel?.getBookProductCount() ?? 0
        XCTAssertLessThanOrEqual(count, 17)
    }

    func testGetReturnProductCount() {
        let count = viewModel?.getReturnProductCount() ?? 0
        XCTAssertLessThanOrEqual(count, 17)
    }

    func testGetProductsForBook() {
        viewModel?.filteredProducts.bind({ products in
            if self.isFirstBind {
                XCTAssertEqual(products.count, 0)
                self.isFirstBind = false
            }
            else {
                XCTAssertLessThanOrEqual(products.count, 17)
            }
        })
        viewModel?.getProductsForBook()
    }

    func testGetProductsForReturn() {
        viewModel?.filteredProducts.bind({ products in
            if self.isFirstBind {
                XCTAssertEqual(products.count, 0)
                self.isFirstBind = false
            }
            else {
                XCTAssertLessThanOrEqual(products.count, 17)
            }
        })
        viewModel?.getProductsForReturn()
    }

    func testGetEstimatedPriceForTenDaysOfFirstProduct() {
        viewModel?.productElements.bind({ products in
            if self.isFirstBind {
                XCTAssertEqual(products.count, 0)
                self.isFirstBind = false
            }
            else {
                let endDate = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
                let price = self.viewModel?.getEstimatedPrice(forProduct: products[0], till: endDate)
                XCTAssertEqual(price, 45000)
            }
        })
        viewModel?.getAllProducts()
    }
}
