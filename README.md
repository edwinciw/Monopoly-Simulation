# Monopoly-Simulation

This project aims to simulate a Monopoly tournament using SQL. The board the game uses is based on Manchester, United Kingdom, which is shown below, the game has 4 players Jane, Norman, Mary, and Bill. The game uses a 6 die to make moves, and each square has different landing effects:

<p align="center">
  <img src="monopoly.jpg"/>
</p>


- Go: All players start the game from here, passing or landing on this square gives £100.
- Properties: All squares with a price and colour is a property square. By landing on these squares, the player can purchase the property if it is not owned by any players, afterwards, other players will need to pay the price shown on the square once landed. In addition, if a player owns all properties of any colour, other players landing on them will need to pay double.
- Community Chests: Players landing here will either get £100 from winning a beauty contest, or pay £30 with library books overdue.
- Chances: Players landing here will either pay £50 to each player, or move forward 3 spaces.
- Free Parking: Nothing happens.
- Jail: Nothing happens.
- Go to Jail: Players landing here will be send to the Jail square, and can only be released from a 6 roll.


## Data Schema
The design of the relational database is shown by the Crow's Foot diagram below, which highlights the relationships between tables and the keys each table has. It is in second normal form where all attributes are dependent on the primary key of their respective table, which improves data integrity by eliminating partial dependencies between tables.

<p align="center">
  <img src="monopoly_cfd.svg"/>
</p>
