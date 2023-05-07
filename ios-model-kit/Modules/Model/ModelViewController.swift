//
//  ModelViewController.swift
//  ios-model-kit
//
//  Created by Oleh Kulakevych on 02.05.2023.
//

import UIKit
import SceneKit
import FirebaseStorage

final class ModelViewController: UIViewController {
    
    @IBOutlet
    weak var sceneView: SCNView!
    
    @IBOutlet
    weak var previewTitleLabel: UILabel!
    
    @IBOutlet
    weak var previewDescriptionLabel: UILabel!
        
    var sceneObjectPath: String!
    var sceneTitle: String!
    var sceneDescription: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        
        if let url = URL(string: sceneObjectPath) {
            loadActivation(isOn: true)
            Downloader.load(url: url) { data in
                DispatchQueue.main.async {
                    if let path = data?.write(withName: self.sceneDescription) {
                        if let s = try? SCNScene(url: path) {
                            self.configureScene(s: s)
                        }
                    }
                    self.loadActivation(isOn: false)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.loadActivation(isOn: false)
            }
            configureScene(s: SCNScene(named: sceneObjectPath))
        }
                        
        previewTitleLabel.text = sceneTitle
        previewDescriptionLabel.text = sceneDescription
    }
    
    private func configureScene(s: SCNScene?) {
        guard let s = s else { return }
        
        let scene = s
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 50, z: 50)
        
        scene.rootNode.addChildNode(cameraNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 50, z: 50)
        
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.lightGray
        
        scene.rootNode.addChildNode(ambientLightNode)
        
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        
        sceneView.scene = scene
    }
    
    private func loadActivation(isOn: Bool) {
        if isOn {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let barButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.setRightBarButton(barButton, animated: true)
            activityIndicator.startAnimating()
        } else {
            self.navigationItem.rightBarButtonItems = []
        }
    }
}

extension Data {

    func write(withName name: String) -> URL? {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        if let _ = try? write(to: url, options: .atomicWrite) {
            return url
        } else {
            return nil
        }
    }
}
