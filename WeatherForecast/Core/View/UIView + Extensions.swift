//
//  UIView + Extensions.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import UIKit
import Foundation

extension UIView {
    func add(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }

    func add(subviews: [UIView]) {
        subviews.forEach{ view in
            self.add(subview: view)
        }
    }
}

extension UIStackView {
    func addArranged(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(subview)
    }

    func addArranged(subviews: [UIView]) {
        subviews.forEach{ view in
            self.addArranged(subview: view)
        }
    }
}

extension UICollectionView {
    func registerCell<T>(_ cell: T.Type) where T: UICollectionViewCell {
        self.register(T.self, forCellWithReuseIdentifier: T.self.description())
    }

    func dequeCell<T>(indexPath: IndexPath) -> T? where T: UICollectionViewCell  {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: T.self.description(),
            for: indexPath
        ) as? T else {
            return nil
        }
        return cell
    }
}
