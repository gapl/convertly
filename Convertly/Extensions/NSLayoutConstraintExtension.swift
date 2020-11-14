//
//  NSLayoutConstraintExtension.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import UIKit

extension NSLayoutConstraint {
    /// Activates constraint and sets `translatesAutoresizingMaskIntoConstraints = false` for its first item.
    var activate: Void {
        isActive = true
        (firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
    }
}
