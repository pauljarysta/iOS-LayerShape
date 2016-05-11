//
//  TrackTouch.swift
//  LayerShape
//
//  Created by Paul Jarysta on 13/04/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

postfix operator ** { }
postfix func ** (value: CGFloat) -> CGFloat {
	return value * value
}

class TrackTouch {
	
	let tolerance = 0.001
	
	var baseTransform = CATransform3DIdentity
	let trackTouchRadius: CGFloat
	let trackTouchCenter: CGPoint
	var trackTouchStartPoint = (x: CGFloat(0.0), y: CGFloat(0.0), z: CGFloat(0.0))
	
	init(location: CGPoint, inRect bounds: CGRect) {
		if CGRectGetWidth(bounds) > CGRectGetHeight(bounds) {
			trackTouchRadius = CGRectGetHeight(bounds) * 0.5
		} else {
			trackTouchRadius = CGRectGetWidth(bounds) * 0.5
		}
		
		trackTouchCenter = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
		setStartPointFromLocation(location)
	}
	
	func setStartPointFromLocation(location: CGPoint) {
		trackTouchStartPoint.x = location.x - trackTouchCenter.x
		trackTouchStartPoint.y = location.y - trackTouchCenter.y
		let distance = trackTouchStartPoint.x** + trackTouchStartPoint.y**
		trackTouchStartPoint.z = distance > trackTouchRadius** ? CGFloat(0.0) : sqrt(trackTouchRadius** - distance)
	}
	
	func finalizeTrackTouchForLocation(location: CGPoint) {
		baseTransform = rotationTransformForLocation(location)
	}
	
	func rotationTransformForLocation(location: CGPoint) -> CATransform3D {
		var trackTouchCurrentPoint = (x: location.x - trackTouchCenter.x, y: location.y - trackTouchCenter.y, z: CGFloat(0.0))
		let withinTolerance = fabs(Double(trackTouchCurrentPoint.x - trackTouchStartPoint.x)) < tolerance && fabs(Double(trackTouchCurrentPoint.y - trackTouchStartPoint.y)) < tolerance
		
		if withinTolerance {
			return CATransform3DIdentity
		}
		
		let distance = trackTouchCurrentPoint.x** + trackTouchCurrentPoint.y**
		
		if distance > trackTouchRadius** {
			trackTouchCurrentPoint.z = 0.0
		} else {
			trackTouchCurrentPoint.z = sqrt(trackTouchRadius** - distance)
		}
		
		let startPoint = trackTouchStartPoint
		let currentPoint = trackTouchCurrentPoint
		let x = startPoint.y * currentPoint.z - startPoint.z * currentPoint.y
		let y = -startPoint.x * currentPoint.z + trackTouchStartPoint.z * currentPoint.x
		let z = startPoint.x * currentPoint.y - startPoint.y * currentPoint.x
		var rotationVector = (x: x, y: y, z: z)
		
		let startLength = sqrt(Double(startPoint.x** + startPoint.y** + startPoint.z**))
		let currentLength = sqrt(Double(currentPoint.x** + currentPoint.y** + currentPoint.z**))
		let startDotCurrent = Double(startPoint.x * currentPoint.x + startPoint.y + currentPoint.y + startPoint.z + currentPoint.z)
		let rotationLength = sqrt(Double(rotationVector.x** + rotationVector.y** + rotationVector.z**))
		let angle = CGFloat(atan2(rotationLength / (startLength * currentLength), startDotCurrent / (startLength * currentLength)))
		
		let normalizer = CGFloat(rotationLength)
		rotationVector.x /= normalizer
		rotationVector.y /= normalizer
		rotationVector.z /= normalizer
		
		let rotationTransform = CATransform3DMakeRotation(angle, rotationVector.x, rotationVector.y, rotationVector.z)
		return CATransform3DConcat(baseTransform, rotationTransform)
	}
	
}
