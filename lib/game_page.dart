import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late String currentplr;
  late bool GameEnd;
  late List<String> occupied;

  static const String plr_x = "X";
  static const String plr_o = "O";

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  initializeGame() {
    currentplr = plr_x;
    GameEnd = false;
    occupied = [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
         elevation: 0,
         title: const Text(
           "Tic Toc Toe",
          style: TextStyle(fontSize: 28, color: Colors.black),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            _headerText(),
            const SizedBox(height: 20,),
            _GameContainer(),
            const SizedBox(height: 20,),
            restartGame(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text(
          "Let's Go",
          style: TextStyle(fontSize: 32, color: Colors.red),
        ),
        SizedBox(height: 20,),
        Text(
          "$currentplr turn",
          style: const TextStyle(fontSize: 32, color: Colors.teal),
        ),
      ],
    );
  }

  Widget _GameContainer() {
    return Container(
      width: MediaQuery.of(context).size.height / 2,
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(color: Colors.transparent),
      margin:const EdgeInsets.all(8),
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => _Box(index),
      ),
    );
  }

  Widget _Box(int index) {
    return GestureDetector(
      onTap: () {
        if (GameEnd || occupied[index].isNotEmpty) {
          return;
        }
        setState(() {
          occupied[index] = currentplr;
          changTurn();
          winnerList();
          isDraw();
        });
      },
      child: Container(
          decoration: BoxDecoration(
              color: (occupied[index].isEmpty)
                  ? Colors.grey
                  : (occupied[index] == plr_x)
                      ? Colors.green.shade200
                      : Colors.orange.shade200,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: (occupied[index].isEmpty)
                  ? Colors.black
                  : (occupied[index] == plr_x)
                  ? Colors.pink
                  : Colors.teal,
              width: 1
            )
          ),
          
          child: Center(
              child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 48),
          ))),
    );
  }

  changTurn() {
    if (currentplr == plr_x) {
      currentplr = plr_o;
    } else {
      currentplr = plr_x;
    }
  }

  winnerList() {
    List<List<int>> winnigList = [
      [0, 1, 2],
      [0, 4, 8],
      [0, 3, 6],
      [1, 4, 7],
      [3, 4, 5],
      [6, 7, 8],
      [2, 5, 8],
      [2, 4, 6],
    ];

    for (var winningpos in winnigList) {
      String plrpos0 = occupied[winningpos[0]];
      String plrpos1 = occupied[winningpos[1]];
      String plrpos2 = occupied[winningpos[2]];

      if (plrpos0.isNotEmpty) {
        if (plrpos0 == plrpos1 && plrpos0 == plrpos2) {
          showGameOverMsg("Player $plrpos0 is won !");
          GameEnd = true;
          return;
        }
      }
    }
  }

  showGameOverMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
        SnackBar(
          backgroundColor: Colors.black.withOpacity(.7),
            content: Text(
            "Game Over \n$msg",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
        )
        )
    );
  }

  restartGame(){
    return ElevatedButton(
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(10),
        backgroundColor: MaterialStatePropertyAll(Colors.pink.shade400)
      ),
        onPressed: (){
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              content:const Text("Sure",style: TextStyle(fontSize: 22),),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                },
                    child:const Text("No",style: TextStyle(color: Colors.red,fontSize: 18),)),
                TextButton(
                    onPressed: (){
                      setState(() {
                        initializeGame();
                      });
                      Navigator.pop(context);
                },
                    child: const Text("Yes",style: TextStyle(color: Colors.green,fontSize: 18),))
              ],
              backgroundColor: Colors.white,
            );
          },);

        },
        child: const Text("Restart Game")
    );

  }

  isDraw(){
    if(GameEnd){
      return;
    }
    bool draw= true;
    for(var occupiedplr in occupied){
      if(occupiedplr.isEmpty){
        draw = false;
      }
    }

    if(draw){
      showGameOverMsg("Match Draw");
      GameEnd = true;
    }
  }
}
