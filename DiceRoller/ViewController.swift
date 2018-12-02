//
//  ViewController.swift
//  DiceRoller
//
//  Created by Mitch Larson on 11/30/18.
//  Copyright © 2018 Mitch Larson. All rights reserved.
//

import UIKit
import SQLite3

class diceCell: UITableViewCell {
    
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var addSubtract: UIStepper!
    @IBOutlet weak var imagecell: UIImageView!
    
    var dice : Dice! {
        didSet {
            addSubtract.value = Double(dice.amount)
            Amount.text = String(dice.amount)
            imagecell.image = UIImage(named: dice.image)!
        }
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        dice.amount = Int(sender.value)
        self.Amount.text = String(format: "%.0f", sender.value)
        
    }

}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RollDice {
    
    var dice : [Dice] = []
    var db: OpaquePointer?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dice"
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("DiceDatabase.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Dice (id INTEGER PRIMARY KEY, amount INTEGER, image TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        readValues()
        if(dice.isEmpty)
        {
            if sqlite3_exec(db, "INSERT INTO Dice (id, amount, image) VALUES (4, 0, 'four'), (6, 0, 'six'), (8, 0, 'eight'), (10, 0, 'ten'), (12, 0, 'twelve'), (20, 0, 'twenty');", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error inserting into table: \(errmsg)")
            }
        }
        readValues()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "rollSegue") {
            for cell in (tableView.visibleCells as! [diceCell])
            {
                updateDice(itemdice: cell.dice)
            }
            readValues()
            let view = segue.destination as! RollViewController
            view.dice = dice
            view.delegate = self
        }
        
    }
    
    
    func readValues(){
        
        //first empty the list of heroes
        dice.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM Dice"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let amount = sqlite3_column_int(stmt, 1)
            let image = String(cString: sqlite3_column_text(stmt, 2))
            
            //adding values to list
            dice.append(Dice(id: Int(id), amount: Int(amount), image: String(describing: image)))
        }
        tableView.reloadData()
        
    }
    
    func UpdateItems() {
        for itemdice in dice
        {
            let queryString = "UPDATE Dice SET amount = ? WHERE Id = ?;"
            
            var stmt: OpaquePointer? = nil
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing update: \(errmsg)")
                return
            }
            
            if sqlite3_bind_int(stmt, 1, Int32(itemdice.amount)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding id: \(errmsg)")
                return
            }
            
            if sqlite3_bind_int(stmt, 2, Int32(itemdice.id)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding id: \(errmsg)")
                return
            }
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure updating hero: \(errmsg)")
                return
            }
            sqlite3_finalize(stmt)
        }
        
        
        readValues()
    }
    
    func updateDice(itemdice : Dice)
    {
        let queryString = "UPDATE Dice SET amount = ? WHERE Id = ?;"
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(itemdice.amount)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, Int32(itemdice.id)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating hero: \(errmsg)")
            return
        }
        sqlite3_finalize(stmt)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var itemdice : Dice!
        itemdice = dice[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! diceCell
        cell.dice = itemdice
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 5
        return cellSpacingHeight
    }
    

}

