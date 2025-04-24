# Monopoly-Simulation

This project aims to simulate a Monopoly tournament using SQL. The board the game uses is based on Manchester, United Kingdom, which is shown below, the game has 4 players Jane, Norman, Mary, and Bill. The game uses a 6 die to make moves, and each square has different **landing effects**:

<p align="center">
  <img src="monopoly.jpg"/>
</p>


- Go: All players start the game from here, passing or landing on this square gives £200.
- Properties: All squares with a price and colour is a property square. By landing on these squares, the player will purchase the property if it is not owned by any players and they have enough money, afterwards, other players will need to pay the price shown on the square once landed. In addition, if a player owns all properties of any colour, other players landing on them will need to pay double.
- Community Chests: Players landing here will either get £100 from winning a beauty contest, or pay £30 with library books overdue.
- Chances: Players landing here will either pay £50 to each player, or move forward 3 spaces.
- Free Parking: Nothing happens.
- Jail: Nothing happens.
- Go to Jail: Players landing here will be send to the Jail square, and can only be released from a 6 roll.


## Data Schema
The design of the relational database is shown by the Crow's Foot diagram below, which highlights the relationships between tables and the keys each table has. It is in **second normal form** where all attributes are dependent on the primary key of their respective table, which improves data integrity by eliminating partial dependencies between tables.

<p align="center">
  <img src="monopoly_cfd.svg"/>
</p>

Relationships between tables:
- Location and Bonus:
  It is one-to-one, each location may have a bonus.
- Location and Player:
  It is one-to-many, each player is at one location.
- Location and Properties:
  It is one-to-one, not every location is a property, but every property must reference a location.
- Player and Properties:
  It is one-to-many, a player may own many properties; a property may be unowned.
- Player and Audit_Trail:
  It is one-to-many, players have multiple audit records during the game.

## Moves Update and Game Logic
Some defaults and triggers will be implemented in this database, to automate some of the game logic based on the landing effects of the squares:
- Players'starting state:
  Defaulted all players start at the "Go" square with £1500 in their balance.
- Jail Mechanic:
  When a player lands on "Go to Jail", the mechanic begins and it will update the player's state and monitors its future rolls until they rolled 6.
- Passing or Landing on "Go":
  Add £200 to players balance when they pass or lands on "Go".
- Landing on a Property:
  Follows the mechanic of the Properties, make purchases and take away players money automatically.
- Audit Trail:
  Auto-fills the Audit_Trail table after any changes in location, balance, or rounds of the players.
- Location Description:
  Update any displays when a players' location is updated.


## How to Run


## Future Works
- **Chance and Community Chest Automation:**  
  Triggers will be implemented to simulate the effects of landing on these squares. For example, drawing a random effect (gain/loss or movement) when a player lands on the respective square.

- **Token Table for Higher Normalization:**  
  A dedicated `Token` table may be introduced to separate tokens from players, further improving normalization and ensuring better data integrity through foreign key constraints.

- **Web Interface for Online Gameplay:**  
  Once the backend logic is fully automated, a web-based interface could be developed to allow users to play the game online with a visual board, interactive turns, and real-time updates.
