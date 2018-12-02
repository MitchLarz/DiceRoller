//
//  RollViewController.swift
//  DiceRoller
//
//  Created by Mitch Larson on 11/30/18.
//  Copyright © 2018 Mitch Larson. All rights reserved.
//

import UIKit

protocol RollDice {
}

class RollViewController: UIViewController, UITableViewDataSource, HolderViewDelegate {
    
    var holderView = HolderView(frame: CGRect.zero)
    var delegate: RollDice?
    var dice : [Dice] = []
    //Set 21 values -- A count is placed in each, with each different location is the 'value'
    var values = Array(repeating: 0, count: 21)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total: UILabel!
    override func viewDidLoad() {
        values = Array(repeating: 0, count: 21)
        //Table hidden for the animation
        tableView.isHidden = true
        total.isHidden = true
        //base method for the animation
        addHolderView()
        super.viewDidLoad()
        RoleTheDice()
    }
    
    //Delegate that leads back to the ViewController from the animation
    func animateTable() {
        holderView.removeFromSuperview()
        
        view.addSubview(self.tableView)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        //Putting the table in the view
                        self.tableView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }, completion: { finished in
            //making them visible
            self.tableView.isHidden = false
            self.total.isHidden = false
        })
    }
    
    //Will set up the frame for the animation, and will call the base method in the class
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }
    
    //Will run through each dice grabbing the rolls
    func RoleTheDice()
    {
        var totalamount = 0
        for diceitem in dice
        {
            var count = diceitem.amount
            while (count > 0)
            {
                let random = Int.random(in: 1 ..< diceitem.id)
                //Adding to the total amount
                totalamount += random
                //incrementing the count
                values[random] += 1
                //decrementer for the while loop
                count = count - 1
            }
        }
        //setting the label after it grabs the values
        total.text = String(totalamount)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "cell", for: indexPath)
        let line = "Roll Amount " + String(indexPath.row)
        cell.textLabel?.text = line
        cell.detailTextLabel?.text = String(values[indexPath.row])
        
        return cell
    }

}
