//
//  GlobalMethod.swift
//  RentProduct
//

import Foundation
import UIKit

class GlobalMethod {

    class func getFirstViewController(ofView view: UIView) -> UIViewController? {
        let firstViewController = sequence(first: view, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }
}
