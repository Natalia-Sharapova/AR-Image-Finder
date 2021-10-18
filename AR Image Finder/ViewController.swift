//
//  ViewController.swift
//  AR Image Finder
//
//  Created by Наталья Шарапова on 17.10.2021.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        //Detect images
        configuration.maximumNumberOfTrackedImages = 2
        configuration.trackingImages =
            ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        //Detect planes
       // configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        switch anchor {
        case let imageAnchor as ARImageAnchor:
            nodeAdded(node, for: imageAnchor)
        case let planeAnchor as ARPlaneAnchor:
            nodeAdded(node, for: planeAnchor)
        default:
            print("Found unknown anchor")
        }
    }
        
        func nodeAdded(_ node: SCNNode, for imageAnchor: ARImageAnchor) {
            //Get image size
            let image = imageAnchor.referenceImage
            let size = image.physicalSize
            
            //Create plane of the same size
            let height = 66 / 65 * size.height
            let width = image.name == "horses" ?
                156 / 150 * 15 / 6.269 * size.width:
               156 / 150 * 15 / 6.1345 * size.width
            
            let plane = SCNPlane(width: width, height: height)
            plane.firstMaterial?.diffuse.contents = image.name == "horses" ?
                UIImage(named: "100dollarsface"): UIImage(named: "100dollarshouse")
        
            //Create node
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            //Move planeNode
           planeNode.position.x -= image.name == "horses" ? 0.01 : 0
            planeNode.position.x += image.name == "theatre" ? 0.01 : 0
            
            //Add planeNode to the given node
            node.addChildNode(planeNode)
    }
        
        func nodeAdded(_ node: SCNNode, for planeAnchor: ARPlaneAnchor) {
            print("Plane \(planeAnchor) added")
    }
}

