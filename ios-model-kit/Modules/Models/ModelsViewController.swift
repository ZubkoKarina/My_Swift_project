//
//  ModelsViewController.swift
//  ios-model-kit
//
//  Created by Karina Zubko on 02.05.2023.
//

import UIKit
import FirebaseDatabase

extension ModelsViewController {
    
    struct ModelStorage: Decodable {
        let id: Int
        let title: String
        let description: String
        let imagePath: String
        let modelPath: String
    }
}

final class ModelsViewController: UIViewController {
    
    @IBOutlet
    weak var tableView: UITableView!
    
    private var ref: DatabaseReference!
    
    private var data: [ModelsViewController.ModelStorage] = []
    
    private var localData: [ModelsViewController.ModelStorage] = [
        ModelsViewController.ModelStorage(id: 0, title: "Ball", description: "kea-checkered-ball-50k-textured", imagePath: "albedo", modelPath: "kea-checkered-ball-50k-textured.obj")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        
        fetchModels()
    }
    
    private func open(model: ModelsViewController.ModelStorage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: ModelViewController.self)) as! ModelViewController
        controller.sceneObjectPath = model.modelPath
        controller.sceneTitle = model.title
        controller.sceneDescription = model.description
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction
    func didTapRefresh(_ sender: UIBarButtonItem) {
        fetchModels()
    }
}

extension ModelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.data.isEmpty {
            return self.localData.count
        } else {
            return self.data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ModelsTableViewCell.self), for: indexPath) as! ModelsTableViewCell
        
        if self.data.isEmpty {
            cell.set(model: localData[indexPath.row])
        } else {
            cell.set(model: data[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.data.isEmpty {
            let item = localData[indexPath.row]
            open(model: item)
        } else {
            let item = data[indexPath.row]
            open(model: item)
        }
    }
    
    private func loadActivation(isOn: Bool) {
        if isOn {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let barButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.setLeftBarButton(barButton, animated: true)
            activityIndicator.startAnimating()
        } else {
            self.navigationItem.leftBarButtonItems = []
        }
    }
}

// MARK:- Firebase Calls

extension ModelsViewController {
    
    func fetchModels() {
        loadActivation(isOn: true)
        ref.child("data").observeSingleEvent(of: .value) { snapshot in
            let models = snapshot.value as? [[String: Any]] ?? []
            let jsonDecoder = JSONDecoder()
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: models, options: .prettyPrinted) else {
                DispatchQueue.main.async {
                    self.loadActivation(isOn: false)
                }
                return
            }
                    
            let objectData = try? jsonDecoder.decode([ModelsViewController.ModelStorage].self, from: jsonData)
            
            self.data = objectData ?? []
            
            DispatchQueue.main.async {
                self.loadActivation(isOn: false)
                self.tableView.reloadData()
            }
        }
    }
}
