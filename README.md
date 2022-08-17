# WordScramble
This game is a project in the 100daysWithSwiftUI aswell as in the UIKit course by Paul Hudson.

Because I'm trying to build more complex apps, I thought about building this one out.

Some changes or additions to the default project:
* the word input is now a textfield, submitting through the submit-key on on the keyboard or the plus-button right next to it
* start-words are there in german and english, based on locale
* checking if word is real now uses a seperate word list, because using the UITextChecker() did not work properly on german words
* scoring system -> up to 3 letters, 1 pt. per letter, after that: 4th letter 2 points, 5th 4 points, 6th 8 points and so on
* score per word is displayed on the leading side of the word
* score per round is shown beneath the textfield
* buttons for resetting or ending the round are now found inside a menu
* resetting game will ask the player if he's sure to reset when there is one or more words already submitted
* ending game will ask for a name and then saves the score to disk (using JSON)

Features to add:
* onboarding on first start of the app
* showing scores, maybe for curent word inside the menu
