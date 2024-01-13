//
//  CircularProgressBarView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 12/31/23.
//

import Foundation
import UIKit

class CircularProgressBar: UIView {
    // Layers for the circular progress bar
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    // Label to display the current value
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()

    // Maximum value for the progress
    var maxValue: CGFloat = 500  // Default maximum value

    // Current progress value
    var progressValue: CGFloat = 0 {
        didSet {
            updateProgressBar()
        }
    }

    // Initializer with frame and maximum value
    init(frame: CGRect, maxValue: CGFloat) {
        self.maxValue = maxValue
        super.init(frame: frame)
        setupLayers()
    }

    // Required initializer for Interface Builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    // Common setup for layers
    private func setupLayers() {
        // Circle Layer
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 10
        circleLayer.fillColor = nil
        circleLayer.strokeColor = UIColor.lightGray.cgColor

        // Progress Layer
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10
        progressLayer.fillColor = nil
        progressLayer.strokeEnd = 0

        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        addSubview(valueLabel)
    }

    // Layout subviews
    // Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
        progressLayer.frame = bounds

        // Circle path with updated arcCenter calculation
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.size.width / 2 - progressLayer.lineWidth, startAngle: -(.pi / 2), endAngle: .pi * 1.5, clockwise: true)
        circleLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath

        // Positioning the label
        valueLabel.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    // Update the progress bar based on the current value
    private func updateProgressBar() {
        // Normalize progress for animation (0.0 to 1.0)
        let normalizedProgress = min(max(progressValue / maxValue, 0), 1)

        // Update progress layer
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = normalizedProgress

        // Update color based on value
        if progressValue < 200 {
            progressLayer.strokeColor = UIColor.green.cgColor
        } else if progressValue < 400 {
            progressLayer.strokeColor = UIColor.yellow.cgColor
        } else {
            progressLayer.strokeColor = UIColor.red.cgColor
        }

        // Update label text with actual integer value
        let displayValue = Int(progressValue)
        valueLabel.text = "\(displayValue)"
        
        CATransaction.commit()
    }
}




