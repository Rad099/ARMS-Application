//
//  GradientView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/10/24.
//
import UIKit

class GradientView: UIView {

    private var gradientLayer = CAGradientLayer()
    private var gradientColors: [CGColor]
    private var gradientLocations: [NSNumber]?

    init(colors: [UIColor], locations: [NSNumber]? = nil) {
        self.gradientColors = colors.map { $0.cgColor }
        self.gradientLocations = locations
        super.init(frame: .zero)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGradient() {
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Top middle
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Bottom middle
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func updateGradient(colors: [UIColor]) {
            self.gradientColors = colors.map { $0.cgColor }
            self.gradientLayer.colors = self.gradientColors
        }
}


