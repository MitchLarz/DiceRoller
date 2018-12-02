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

class RollViewController: UIViewController, UITableViewDataSource {
    var delegate: RollDice?
    var dice : [Dice] = []
    var values = Array(repeating: 0, count: 21)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total: UILabel!
    override func viewDidLoad() {
        values = Array(repeating: 0, count: 21)
        super.viewDidLoad()
        RoleTheDice()
    }
    
    func RoleTheDice()
    {
        var totalamount = 0
        for diceitem in dice
        {
            var count = diceitem.amount
            while (count > 0)
            {
                let random = Int.random(in: 1 ..< diceitem.id)
                totalamount += random
                values[random] += 1
                count = count - 1
            }
        }
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
