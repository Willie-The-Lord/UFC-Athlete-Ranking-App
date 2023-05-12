import UIKit

class PieChartView: UIView {
    
    var data: [CGFloat] = [30, 20, 50] // example data
    var colors: [UIColor] = [UIColor(red: 37/255, green: 150/255, blue: 190/255, alpha: 1.0), UIColor(red: 216/255, green: 12/255, blue: 12/255, alpha: 1.0), .gray.withAlphaComponent(0.7)] // example colors
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        let total = data.reduce(0, +)
        var startAngle: CGFloat = 0
        
        for (index, slice) in data.enumerated() {
            let endAngle = startAngle + slice / total * 2 * .pi
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            colors[index].setFill() // set a color for each slice
            path.fill()
            startAngle = endAngle
        }
    }
}


