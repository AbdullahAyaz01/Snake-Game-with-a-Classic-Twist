Project Title: 

               Snake Game: Classic Game with a Twist
Overview:
This proposal outlines the development of a Snake game with a unique twist: randomly generated snakes appear on the game board as additional obstacles. The game will be implemented using Microsoft Macro Assembler (MASM) with the Irvine32 library in Visual Studio, targeting a console-based application for Windows. The core mechanics follow the classic Snake game, with the added challenge of avoiding randomly spawned snakes.
Objectives:
•	Develop a playable Snake game in Assembly Language.
•	Introduce an autonomous enemy snake to increase difficulty.
•	Implement real-time player controls snake.
•	Provide essential game interface elements such as scoring and game-over screens.
Methodology:
This section outlines the methodology employed to develop the console-based Snake game with a random snake twist, implemented using Microsoft Macro Assembler (MASM) and the Irvine32 library in Visual Studio. The approach encompasses the development process, including design, implementation, testing, and documentation, to ensure a functional and engaging game. The methodology is structured to achieve the project objectives of creating a playable game with core mechanics, a random snake feature, and a user-friendly interface.
Game Features:
Core Mechanics:
•	Player-Controlled Snake: The player navigates a snake using keyboard inputs to collect food.
•	Food Collection: Eating food increases the snake’s length and adds to the player’s score.
•	Score System: Each food consumed grants points.
•	Game Over Conditions:
o	The snake collides with the walls.
o	The snake collides with itself.
o	The snake collides with a randomly generated snake.
Random Snake:
•	Random Snake Generation: A new snake appears at a random position on the board.
•	Random Snake Behavior: These snakes move in random directions.
•	Collision Risk: If the player’s snake collides with a random snake, the game ends.
User Interface:
•	Game Board: A console-based wall.
•	Visuals:
o	Player’s snake
o	Random snakes
o	Food.
o	Walls
•	Score Display: Real-time score shown at the top of the console.
Technical Implementations:
Technology Stack:
•	MASM: Used for low-level programming and game logic.
•	Library: Irvine32
•	Visual Studio: Development environment for writing, assembling, and debugging the code.
Deliverables:
•	A fully functional console-based Snake game executable.
•	Well-commented MASM source code for maintainability.
•	A brief user guide explaining controls and the random snake twist.
