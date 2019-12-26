//
//  ViewController.swift
//  Inkz
//
//  Created by Chuck Deerinck on 12/23/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var mainView: SCNView!
    let rootNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.scene = SCNScene()
        let boardGeometry = SCNPlane(width: 8, height: 8)
        boardGeometry.cornerRadius = 0.5
        boardGeometry.firstMaterial?.diffuse.contents = UIImage(named: "Chessboard.png") // #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)  //UIColor.orange
        let boardNode = SCNNode(geometry: boardGeometry)

        let myLight = SCNLight()
        //myLight.castsShadow = true
        myLight.type = .directional
        myLight.color = UIColor.white
        let lightNode = SCNNode()
        lightNode.light = myLight
        mainView.scene?.rootNode.addChildNode(lightNode)
        //mainView.scene?.lightingEnvironment.intensity = 2.0
        let texture = UIImage(named: "Crumpled.png")

        for x in stride(from:-3.5, through:3.5, by: 1.0) {
            for y in stride(from:-3.5, through:3.5, by: 1.0) {
                let marble = SCNNode(geometry: SCNSphere(radius: 0.45))
                //marble.geometry?.firstMaterial?.lightingModel = .physicallyBased
                //marble.geometry?.firstMaterial?.specular.contents = texture
                marble.geometry?.firstMaterial?.emission.contents = texture
                //marble.geometry?.firstMaterial?.metalness.contents = texture
                marble.geometry?.firstMaterial?.roughness.contents = texture
                marble.geometry?.firstMaterial?.diffuse.contents = UIColor(hue: quanta(by:6), saturation: 1.0, brightness: 1.0, alpha: 1.0) //#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
                marble.position.x = Float(Double(x)*0.95)
                marble.position.y = Float(Double(y)*0.95)
                marble.position.z = 0.5
                marble.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: Double.random(in: 0...5)+5)))
                mainView.scene?.rootNode.addChildNode(marble)
            }
        }

        mainView.scene?.rootNode.addChildNode(boardNode)
        mainView.allowsCameraControl = true


    }

    var directionVector:SCNVector3 = SCNVector3()
    var zCoordinate: Float = 0
    var offset: SCNVector3 = SCNVector3()
    var touchedMarble: [SCNHitTestResult] = []

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchedMarble = mainView.hitTest(touch.location(in: mainView), options: [.rootNode: mainView.scene?.rootNode as Any, .searchMode: SCNHitTestSearchMode.closest.rawValue])
        if let worldCoordinates = touchedMarble.first?.worldCoordinates { //#2
            mainView.allowsCameraControl = false
            directionVector = self.mainView.projectPoint(worldCoordinates) //#3
            zCoordinate = directionVector.z
            offset = worldCoordinates - touchedMarble.first!.localCoordinates //#4
            print("Mouse down", touch.location(in: mainView), touchedMarble.first?.node.geometry?.firstMaterial?.diffuse.contents as Any)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchedMarble != [] {
            let touch = touches.first!
            let v = SCNVector3(touch.location(in: mainView).x, touch.location(in: mainView).y, CGFloat(zCoordinate))
            let up = mainView.unprojectPoint(v)
            let np = (touchedMarble.first?.node.position)! + up - offset
            touchedMarble.first?.node.position = np
            offset = up
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.allowsCameraControl = true
    }
}

extension SCNVector3 {
    static func - (_ left: SCNVector3, _ right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    static func + (_ left: SCNVector3, _ right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
}

extension ViewController: SCNSceneRendererDelegate {

}

