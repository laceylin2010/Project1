//
//  InfoViewController.swift
//  Project1
//
//  Created by Lacey Vu on 2/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, Identity, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var matches: Matches!

    class func id() -> String
    {
        return "InfoViewController"
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = matches.recipeName
        setupRecipe()
       

    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var numberOfRows = Int()
        
        if section == 0 {
            numberOfRows = 1
        } else {
            guard let ingredients = matches.ingredients else { return 0 }

            numberOfRows = ingredients.count
        }
        
        return numberOfRows
    }
   
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var header = String()
        
        if section == 1{
            header = "Ingredients"
        }
        
        return header
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        
        if indexPath.section ==  0 {
            if let cell = self.tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as? InfoTableViewCell{
                cell.matches = matches
                cell.ratingLabel.text = "Rating: \(matches.rating)"
                if let timeCell = matches.totalTime {
                    cell.timeLabel.text = "Total Time: About \(timeCell)"
                } else {
                    cell.timeLabel.text = "No estimated time"
                }
                
            }
        } else if indexPath.section == 1 {
            cell = self.tableView.dequeueReusableCellWithIdentifier("ingredientsCell", forIndexPath: indexPath)
            cell.textLabel?.text = matches.ingredients![indexPath.row]
        }
        
        return cell

    }
    
    
    func setupRecipe()
    {
            API.shared.getImage(matches.recipeImage, completion: { (image) -> () in
                self.imageView.image = image
            })
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 75
        }
        return tableView.rowHeight
    }

}

extension InfoViewController
{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == WebViewController.id(){
            if let webViewController = segue.destinationViewController as? WebViewController{
                    webViewController.matches = self.matches
            }
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 0 {
            self.performSegueWithIdentifier("WebViewController", sender: nil)
        } else if indexPath.section == 1 {
            let popup = UIAlertController(title: "Add to Grocery List", message: "Would you like to add this to your grocery list?", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                guard let object = self.matches.ingredients?[indexPath.row] else { return }
                let ingredient = Grocery(groceryItem: object)
                GroceryMemory.shared.add(ingredient)

            })
            let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
            popup.addAction(confirmAction)
            popup.addAction(cancelAction)
            self.presentViewController(popup, animated: true, completion: nil)
        }
       
    }
    

}

    

    



