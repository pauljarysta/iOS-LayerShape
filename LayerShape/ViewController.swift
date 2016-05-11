//
//  ViewController.swift
//  LayerShape
//
//  Created by Paul Jarysta on 13/04/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit
import CoreMotion

func degreesToRadians(degrees: Double) -> CGFloat {
	return CGFloat(degrees * M_PI / 180.0)
}

func radiansToDegrees(radians: Double) -> CGFloat {
	return CGFloat(radians / M_PI * 180.0)
}

class ViewController: UIViewController {
	
	@IBOutlet weak var viewForTransformLayer: UIView!
	@IBOutlet weak var lb_title: UILabel!
	@IBOutlet weak var lb_x: UILabel!
	@IBOutlet weak var lb_y: UILabel!
	@IBOutlet weak var lb_z: UILabel!
	@IBOutlet weak var lb_rotation_type: UILabel!
	
	
	let sideLength = CGFloat(160.0)
	
	var transformLayer: CATransformLayer!
	var trackTouch: TrackTouch?
	let manager = CMMotionManager()
	
	var color1 = UIColor.blue1()
	var color2 = UIColor.blue2()
	var color3 = UIColor.blue3()
	var color4 = UIColor.blue4()
	var color5 = UIColor.blue5()
	var color6 = UIColor.blue6()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewForTransformLayer.backgroundColor = UIColor.whiteColor()
		buildCube()
		addGyroHoriz()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let location = touches.first?.locationInView(viewForTransformLayer) {
			if trackTouch != nil {
				trackTouch?.setStartPointFromLocation(location)
			} else {
				trackTouch = TrackTouch(location: location, inRect: viewForTransformLayer.bounds)
			}
			
			for layer in transformLayer.sublayers! {
				if layer.hitTest(location) != nil {
					break
				}
			}
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let location = touches.first?.locationInView(viewForTransformLayer) {
			if let transform = trackTouch?.rotationTransformForLocation(location) {
				viewForTransformLayer.layer.sublayerTransform = transform
			}
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let location = touches.first?.locationInView(viewForTransformLayer) {
			trackTouch?.finalizeTrackTouchForLocation(location)
		}
	}
	
	// MARK: - Helpers
	
	func buildCube() {
		transformLayer = CATransformLayer()
		
		// Layer 1
		var layer = sideLayerWithColor(color1)
		transformLayer.addSublayer(layer)
		
		// Layer 2
		layer = sideLayerWithColor(color2)
		var transform = CATransform3DMakeTranslation(sideLength / 2.0, 0.0, sideLength / -2.0)
		transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
		layer.transform = transform
		transformLayer.addSublayer(layer)
		
		// Layer 3
		layer = sideLayerWithColor(color3)
		layer.transform = CATransform3DMakeTranslation(0.0, 0.0, -sideLength)
		transformLayer.addSublayer(layer)
		
		// Layer 4
		layer = sideLayerWithColor(color4)
		transform = CATransform3DMakeTranslation(sideLength / -2.0, 0.0, sideLength / -2.0)
		transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
		layer.transform = transform
		transformLayer.addSublayer(layer)
		
		// Layer 5
		layer = sideLayerWithColor(color5)
		transform = CATransform3DMakeTranslation(0.0, sideLength / -2.0, sideLength / -2.0)
		transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
		layer.transform = transform
		transformLayer.addSublayer(layer)
		
		// Layer 6
		layer = sideLayerWithColor(color6)
		transform = CATransform3DMakeTranslation(0.0, sideLength / 2.0, sideLength / -2.0)
		transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
		layer.transform = transform
		transformLayer.addSublayer(layer)
		
		transformLayer.anchorPointZ = sideLength / -2.0
		viewForTransformLayer.layer.addSublayer(transformLayer)
	}
	
	func addGyroHoriz() {
		
		manager.stopGyroUpdates()
		if manager.gyroAvailable {
			manager.gyroUpdateInterval = 0.1
			manager.startGyroUpdates()
			
			let queue = NSOperationQueue.mainQueue()
			manager.startGyroUpdatesToQueue(queue) { data, error in
				
				if self.manager.deviceMotionAvailable {
					self.manager.deviceMotionUpdateInterval = 0.01
					
					self.manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {data, error in
						
						let rotationHoriz = atan2(data!.gravity.x, data!.gravity.y) - M_PI
						
						self.viewForTransformLayer.transform = CGAffineTransformMakeRotation(CGFloat(rotationHoriz))
						self.lb_x.text = "x : \(Double(round(1000 * (data?.gravity.x)!) / 1000))"
						self.lb_y.text = "y : \(Double(round(1000 * (data?.gravity.y)!) / 1000))"
						self.lb_z.text = "z : \(Double(round(1000 * (data?.gravity.z)!) / 1000))"
					}
				}
			}
		}
	}

	func addGyroVert() {

		manager.stopGyroUpdates()
		if manager.gyroAvailable {
			manager.gyroUpdateInterval = 0.1
			manager.startGyroUpdates()
			
			let queue = NSOperationQueue.mainQueue()
			manager.startGyroUpdatesToQueue(queue) { data, error in
				
				if self.manager.deviceMotionAvailable {
					self.manager.deviceMotionUpdateInterval = 0.01
					
					self.manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {data, error in
						
						let rotationVert = atan2(data!.gravity.y, data!.gravity.z) - M_PI
						
						self.viewForTransformLayer.transform = CGAffineTransformMakeRotation(CGFloat(rotationVert))
						self.lb_x.text = "x : \(Double(round(1000 * (data?.gravity.x)!) / 1000))"
						self.lb_y.text = "y : \(Double(round(1000 * (data?.gravity.y)!) / 1000))"
						self.lb_z.text = "z : \(Double(round(1000 * (data?.gravity.z)!) / 1000))"
					}
				}
			}
		}
	}

	func sideLayerWithColor(color: UIColor) -> CALayer {
		let layer = CALayer()
		layer.frame = CGRect(origin: CGPointZero, size: CGSize(width: sideLength, height: sideLength))
		layer.position = CGPoint(x: CGRectGetMidX(viewForTransformLayer.bounds), y: CGRectGetMidY(viewForTransformLayer.bounds))
		layer.backgroundColor = color.CGColor
		return layer
	}
	
	@IBAction func switchRotationType(sender: UISwitch) {
		
		if sender.on {
			lb_rotation_type.text = "Gyro orientation: Vertical"
			addGyroVert()
		} else {
			lb_rotation_type.text = "Gyro orientation: Horizontal"
			addGyroHoriz()
		}
	}
}

