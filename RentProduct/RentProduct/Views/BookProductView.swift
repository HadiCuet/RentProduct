//
//  BookProductView.swift
//  RentProduct
//
//  Created by Abdullah Al Hadi on 22/10/22.
//

import UIKit

class BookProductView: UIView {

    let bgView = UIView()
    let containerView = UIView()
    var viewWidth : CGFloat = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBGView()
        self.setupContainerView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.viewWidth = frame.size.width
        self.setupBGView()
        self.setupContainerView()
    }

    private func setupContainerView() {
        containerView.frame = CGRect(x: 0, y: 0, width: self.viewWidth - 80, height: 300)
        containerView.center = bgView.center
        containerView.backgroundColor = .white
        containerView.isUserInteractionEnabled = false
        bgView.addSubview(containerView)

        self.addTextField()
    }

    private func addTextField() {
        let containerWidth = self.containerView.frame.size.width
        let textField = UITextField(frame: CGRect(x: 20, y: 20, width: containerWidth - 40, height: 80))
        textField.text = "Dummy Text - Abdullah Al Hadi"
        textField.textAlignment = .center
        self.containerView.addSubview(textField)
    }

    private func setupBGView() {
        bgView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        bgView.backgroundColor = .blue.withAlphaComponent(0.3)
        self.addSubview(bgView)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        bgView.addGestureRecognizer(gesture)
    }

    @objc private func dismissView(_ sender: UITapGestureRecognizer?) {
        self.removeFromSuperview()
    }
}

extension BookProductView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if containerView.frame.contains(touch.location(in: bgView)) {
            return false
        }
        return true
    }
}
