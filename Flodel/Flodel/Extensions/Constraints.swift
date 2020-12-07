//
//  Constraints.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 07/12/2020.
//

import UIKit

enum Anchor {
    case left(padding: CGFloat?, from: NSLayoutXAxisAnchor?)
    case top(padding: CGFloat?, from: NSLayoutYAxisAnchor?)
    case right(padding: CGFloat?, from: NSLayoutXAxisAnchor?)
    case bottom(padding: CGFloat?, from: NSLayoutYAxisAnchor?)
    
    case leading(padding: CGFloat?, from: NSLayoutXAxisAnchor?)
    case trailing(padding: CGFloat?, from: NSLayoutXAxisAnchor?)
    
    case horizontal(padding: CGFloat?)
    case vertical(padding: CGFloat?)
    
    case xAxis(padding: CGFloat?, from: NSLayoutXAxisAnchor?)
    case yAxis(padding: CGFloat?, from: NSLayoutYAxisAnchor?)
    
    case height(_ value: CGFloat?)
    case width(_ value: CGFloat?)
    
    case center
}

extension UIView {
    
    func setConstraints(_ constraints: [Anchor]) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for constraint in constraints {
            switch constraint {
            case .left(let padding, let from):
                if let from = from {
                    self.leftAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.leftAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.leftAnchor, constant: padding ?? 0).isActive = true
                }
            case .top(padding: let padding, from: let from):
                if let from = from {
                    self.topAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.topAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.topAnchor, constant: padding ?? 0).isActive = true
                }
            case .right(padding: let padding, from: let from):
                if let from = from {
                    self.rightAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.rightAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.rightAnchor, constant: padding ?? 0).isActive = true
                }
            case .bottom(padding: let padding, from: let from):
                if let from = from {
                    self.bottomAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.bottomAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.bottomAnchor, constant: padding ?? 0).isActive = true
                }
            case .leading(padding: let padding, from: let from):
                if let from = from {
                    self.leadingAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: padding ?? 0).isActive = true
                }
            case .trailing(padding: let padding, from: let from):
                if let from = from {
                    self.trailingAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: padding ?? 0).isActive = true
                }
            case .horizontal(padding: let padding):
                self.leadingAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.leadingAnchor, constant: padding ?? 0).isActive = true
                self.trailingAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.trailingAnchor, constant: -1 * (padding ?? 0)).isActive = true
            case .vertical(padding: let padding):
                self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: padding ?? 0).isActive = true
                self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: padding ?? 0).isActive = true
            case .xAxis(padding: let padding, from: let from):
                if let from = from {
                    self.centerXAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor, constant: padding ?? 0).isActive = true
                }
            case .yAxis(padding: let padding, from: let from):
                if let from = from {
                    self.centerYAnchor.constraint(equalTo: from, constant: padding ?? 0).isActive = true
                } else {
                    self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor, constant: padding ?? 0).isActive = true
                }
            case .center:
                self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
                self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
            
            case let .height(value):
                self.heightAnchor.constraint(equalToConstant: value!).isActive = true
                
            case let .width(value):
                self.widthAnchor.constraint(equalToConstant: value!).isActive = true
            }
        }
    }
}

