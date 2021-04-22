//
//  CardCollectionViewController.swift
//  StarWarsCardGame
//
//  Created by David Boyd on 4/22/21.
//

import UIKit

class CardCollectionViewController: UICollectionViewController {

    //MARK: - Properties
    var displayedCharacters: [Character] = []
    var targetedCharacter: Character?
    var selectedFaction = "jedi"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        shuffleCharacters(faction: selectedFaction)
    }

    //MARK: - Helper Methods
    func shuffleCharacters(faction: String) {
        if faction == "jedi" {
            let shuffledJediGroup = CharacterController.jedi.shuffled()
            let jediGroup = shuffledJediGroup.prefix(3)
            displayedCharacters = Array(jediGroup)
            targetedCharacter = CharacterController.sith.randomElement()
        } else {
            let shuffledSithGroup = CharacterController.sith.shuffled()
            let sithGroup = shuffledSithGroup.prefix(3)
            displayedCharacters = Array(sithGroup)
            targetedCharacter = CharacterController.jedi.randomElement()
        }
        updateViews()
    }
    
    func updateViews() {
        guard let character = targetedCharacter else {return}
        displayedCharacters.append(character)
        displayedCharacters.shuffle()
        self.title = "Find \(character.name)"
        collectionView.reloadData()
    }
    
    func presentAlert(character: Character) {
        let success = character == targetedCharacter
        
        let alertController = UIAlertController(title: success ? "Good Job" : "Better luck next time", message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .cancel)
        let shuffleAction = UIAlertAction(title: "Shuffle", style: .default) { (_) in
            self.shuffleCharacters(faction: self.selectedFaction)
        }
        
        alertController.addAction(doneAction)
        
        if success {
            alertController.addAction(shuffleAction)
        }
        
        present(alertController, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilterVC" {
            guard let destination = segue.destination as? FilterViewController else {return}
            //Step 4 (put this where the connection of the button to)
            destination.delegate = self
        }

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedCharacters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCollectionViewCell else {return UICollectionViewCell()}
        
        let character = displayedCharacters[indexPath.row]
        
        cell.character = character
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //presentAlert
        let character = displayedCharacters[indexPath.row]
        presentAlert(character: character)
    }

}//End of class

//MARK: - Extension
extension CardCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2
        return CGSize(width: width - 20, height: width + 30)
    }
    
}//End of extension


//Step 3
extension CardCollectionViewController: FilterSelectionDelegate {
    func factionWasSelected(faction: String) {
        selectedFaction = faction
        shuffleCharacters(faction: faction)
    }
} //End of extension
