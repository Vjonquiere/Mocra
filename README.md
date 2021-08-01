

## Mocra
**Summary:**

 1. What is mocra ?
 2. Project progress
 3. Future features
 
 ## 1. What's Mocra?
Mocra is a game project wich aims to improve my dev skills, especially in Networking. So Mocra is an online card collection, in fact this is a fusion between art and game-dev. All cards are created from scratch and aren't images from google (even if some images are inspired by artists, existing images).

The collection is divided into **series**, that are sets of cards in link. The collection is also divided into **editions**. A new edtion is created when there is big drop of new cards.

So cards can be classified easily beacause on top of the series and editions, there are many scarcities with different drop rate:
|Common|Not Much Common  |Unusual | Rare | Extremely rare | Unbeleivable |Mythic|Rainbow
|--|--|--|--|--|--|--|--|--|
| 1 - 0,7 | 0,7 - 0,1 |  0,1 - 0,05 | 0,04 - 0,01 | 0,01 - 0,007 | 0,006 - 0,003 | 0,002 - 0,001 | 0,0099 - -∞

The goal of the game is to cellect all of the cards but to do it with different ways: by opening packs, by trade, by playing mini-games.

The code of Mocra client is protected by **Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)**, so you can use or modify it as you want (but not as commercial use). However the server is private, in this github don't have access to it to forbid private server.


## 2. Project Progress

**20/06:**

 - Project is only written in python (client interface made with tkinter)
 - First server/client interactions 
 - Login/Register features working
 - Database infrastructure is defined
 
 **23/06**:
 
 - Database infrastructure is setup
 - Opening system is working 
 - 3 test cards are available

**5/07:**

 - Server can now manage several clients at same time
 - cards are saved in DB
 - Project is limited by Tkinter -> searching a Game engine for simplicity

**15/07:**

 - Godot is choosed to make the client side
 - The server stay written in python

**1/08:**

 - First commit of the new version of Mocra
 - All features have been adapted to godot
 - Starting to create new features

## 3. Future features

 - [ ] *Battle Mod:* 2 players are opening a pack at the same time . Every scarcity give a special amout of point, at the end of the opening the player who has the most points get his cards and the cards of the opponent. The price to play is less than a classic pack 
 
 - [ ] *Trade system:* Players can exchange cards with cards/credits
 
 - [ ] *Shop:* Players can sell their cards to a shop with moving prices in order to get credits
 
 
 - [ ] *Collection*: Players can see their entire card collection

 


