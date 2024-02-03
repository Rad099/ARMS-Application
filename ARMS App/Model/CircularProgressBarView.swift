import UIKit

class CustomProgressView: UIView {
    private var progressLayer = CAShapeLayer()
    private var backgroundLayer = CAShapeLayer()
    private var triangleImageView = UIImageView()
    private var progress: CGFloat = 0.3
    private var degrees: CGFloat = -110

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupTriangleImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
        setupTriangleImageView()
    }

    private func setupLayers() {
        backgroundLayer.strokeColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = 12
        layer.addSublayer(backgroundLayer)

        progressLayer.strokeColor = UIColor.red.cgColor // Use a gradient for actual implementation
        progressLayer.fillColor = nil
        progressLayer.lineWidth = 12
        layer.addSublayer(progressLayer)
    }

    private func setupTriangleImageView() {
        triangleImageView.image = UIImage(named: "triangle") // Replace with your triangle image
        addSubview(triangleImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        progressLayer.frame = bounds
        triangleImageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        configureLayers()
    }

    private func configureLayers() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - progressLayer.lineWidth / 2
        let startAngle = CGFloat(-0.5 * .pi)
        let endAngle = CGFloat(1.5 * .pi)

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        updateProgressLayer()
    }

    private func updateProgressLayer() {
        progressLayer.strokeEnd = progress
        triangleImageView.transform = CGAffineTransform(rotationAngle: degrees * (.pi / 180))
    }

    func setProgress(_ progress: CGFloat, animated: Bool) {
        self.progress = progress
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.35
            animation.toValue = progress
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            progressLayer.add(animation, forKey: "progress")
        } else {
            updateProgressLayer()
        }
    }

    func setRotationDegrees(_ degrees: CGFloat, animated: Bool) {
        self.degrees = degrees
        if animated {
            UIView.animate(withDuration: 0.35) {
                self.triangleImageView.transform = CGAffineTransform(rotationAngle: degrees * (.pi / 180))
            }
        } else {
            updateProgressLayer()
        }
    }
}



