//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 15/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

struct TVShowItem {
    let name: String
}

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let items = [
        TVShowItem(name: "Fringe"),
        TVShowItem(name: "Dexter"),
        TVShowItem(name: "Fringe"),
        TVShowItem(name: "Dexter"),
        TVShowItem(name: "Fringe"),
        TVShowItem(name: "Dexter"),
        TVShowItem(name: "Fringe"),
        TVShowItem(name: "Dexter"),        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        // Do any additional setup after loading the view.
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        
        // We need to dequeue instance of `UITableViewCell`
        // What does that even mean right??
        // Well in order for our scrolling TVShows to perform smoothly, OS will try and reuse table view cells to achieve 60 FPS while scrolling
        
        // How will it achieve that?
        // Well once the cell goes off screen, it will be prepared for reuse for the next data set (next TVShowItem)
        // This will keep memory in check.
        
        // If we are using Storboards or XIBs to create table view cells we need to use some sort of identifier, so that the system later on knows which cell to reuse
        
        // Identifier should be setup inside the interface builder, rule of thumb is to set it to be named as the subclass that we use
        // When you select your UITableViewCell in IB, yo can go to the Attributes Inspector (fourth icon in the right menu)
        // and there you can setup Identifier.
        
        // For that reason, we don't need to use String which is error prone and just plain disqusting, but we can use class name and convert it to String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TvShowsTableViewCell.self), for: indexPath) as! TvShowsTableViewCell
        
        // Once we get a reference to UITableViewCell, more specifically our special subclass, we want to configure it with our data
        // As we have already learned to not leak implementation details, in this case that would mean our label and image, we need to pass in the data
        // With this in place, adhere to Encapsulation principle of object oriented programming
        // Yes sure we can improve this further by using a protocol, but for now we will settle on this approach
        
        cell.configure(with: items[indexPath.row])
        
        // After our special cell is configured, we just return it so that it can be displayed
        
        return cell
    }
}

private extension HomeViewController {
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}


