import 'dart:convert';
import 'dart:math';

import 'package:word_puzzle_english/pages/home_page.dart';
import 'package:word_puzzle_english/utilities/my_constant.dart';
import 'package:word_puzzle_english/utilities/my_dialog.dart';
import 'package:word_puzzle_english/utilities/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_search/word_search.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GlobalKey<_WordFindWidgetState> globalKey = GlobalKey();
  final String apiUrl = "${MyConstant.domain}/api/getQuestion.php";

  // late List<WordFindQues> listQuestions;
  late List<WordFindQues> listQuestions = [];

  @override
  void initState() {
    super.initState();
    listQuestions = [
      //static question for test..
      WordFindQues(
        question: "What is this?",
        answer: "waterfall",
        pathImage:
            "https://media.nationalgeographic.org/assets/photos/000/207/20782.jpg",
      ),
      WordFindQues(
        question: "What is this?",
        answer: "volcano",
        pathImage:
            "https://cdnuploads.aa.com.tr/uploads/Contents/2020/12/01/thumbs_b_c_39772b8a7065338488c2c0d4e67abb91.jpg?v=101003",
      ),
      WordFindQues(
        question: "What is this?",
        answer: "island",
        pathImage: "https://ychef.files.bbci.co.uk/1600x900/p08p0nxj.webp",
      ),
      WordFindQues(
        question: "What are they doing?",
        answer: "exercise",
        pathImage:
            "https://cdn1.coachmag.co.uk/sites/coachmag/files/styles/16x9_746/public/2020/01/best-abs-exercises.jpg?itok=uPwGcqDe&timestamp=1580231579",
      ),
      WordFindQues(
        question: "What is he doing?",
        answer: "meditate",
        pathImage:
            "https://cdn.vox-cdn.com/thumbor/b-sqEZQvIce4dlBeU2HF7YUTjE0=/0x0:5000x5000/920x0/filters:focal(0x0:5000x5000):format(webp):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/19586934/meditation_1_GettyImages_1126494841.jpg",
      ),
      WordFindQues(
        question: "Burj Khalifa is the _____ building in the world. (tall)",
        answer: "tallest",
        pathImage:
            "https://images2.minutemediacdn.com/image/upload/c_crop,h_1192,w_2123,x_0,y_70/f_auto,q_auto,w_1100/v1559225783/shape/mentalfloss/584459-istock-183342824.jpg",
      ),
      WordFindQues(
        question: "Maldives is the _____ country in Asia. (small)",
        answer: "smallest",
        pathImage:
            "https://qph.fs.quoracdn.net/main-qimg-e03f289b2e17ea654bbcc26ac3ac4221",
      ),
      WordFindQues(
        question: "Thailand is ____ than Korea. (hot)",
        answer: "hotter",
        pathImage:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_Thailand.svg/1280px-Flag_of_Thailand.svg.png",
      ),
      WordFindQues(
        question: "Yala is the ____ province of Thailand. (southern)",
        answer: "southernmost",
        pathImage:
            "https://upload.wikimedia.org/wikipedia/commons/a/a5/1364915191-014-o.jpg",
      ),
      WordFindQues(
        question: "Blue whale is the ____ animal in the world. (large)",
        answer: "largest",
        pathImage:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Anim1754_-_Flickr_-_NOAA_Photo_Library.jpg/1280px-Anim1754_-_Flickr_-_NOAA_Photo_Library.jpg",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: MyColors.primary,
          child: Column(
            children: [
              Expanded(
                // for static question...
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: MyColors.primary,
                      child: WordFindWidget(
                        constraints.biggest,
                        listQuestions.map((ques) => ques.clone()).toList(),
                        globalKey,
                        key: globalKey,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordFindWidget extends StatefulWidget {
  Size size;
  List<WordFindQues> listQuestions;
  GlobalKey<_WordFindWidgetState> globalKey;
  WordFindWidget(this.size, this.listQuestions, this.globalKey, {Key? key})
      : super(key: key);

  @override
  _WordFindWidgetState createState() => _WordFindWidgetState();
}

int corrected = 0;

class _WordFindWidgetState extends State<WordFindWidget> {
  late Size size;
  late List<WordFindQues> listQuestions;
  int indexQues = 0;
  int hintCount = 0;
  int hintLimit = 3;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    generatePuzzle();
  }

  @override
  Widget build(BuildContext context) {
    WordFindQues currentQues = listQuestions[indexQues];

    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => generateHint(),
                  child: Icon(
                    Icons.help,
                    size: 45,
                    color: hintCount < hintLimit
                        ? MyColors.secondary
                        : MyColors.grey,
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.globalKey.currentState?.generatePuzzle(
                      loop: listQuestions.map((ques) => ques.clone()).toList(),
                    );
                    corrected = 0;
                  },
                  child: Icon(
                    Icons.loop,
                    size: 45,
                    color: MyColors.secondary,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: indexQues != 0
                          ? () => generatePuzzle(left: true)
                          : null,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 45,
                        color:
                            indexQues != 0 ? MyColors.secondary : MyColors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: indexQues != listQuestions.length - 1
                          ? () => generatePuzzle(next: true)
                          : null,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 45,
                        color: indexQues != listQuestions.length - 1
                            ? MyColors.secondary
                            : MyColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxWidth: size.width / 2 * 1.5),
                child: currentQues.pathImage != 'null'
                    ? Image.network(
                        currentQues.pathImage!,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              currentQues.question ?? "Word Question",
              style: GoogleFonts.chakraPetch(
                fontSize: 25,
                color: MyColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: currentQues.puzzles.map((puzzle) {
                        Color color = MyColors.white;
                        if (currentQues.isDone)
                          color = MyColors.success;
                        else if (puzzle.hintShow)
                          color = MyColors.secondary;
                        else if (currentQues.isFull)
                          color = MyColors.danger;
                        else
                          color = MyColors.white;

                        return InkWell(
                          onTap: () {
                            if (puzzle.hintShow || currentQues.isDone) return;
                            currentQues.isFull = false;
                            puzzle.clearValue();
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // width: constraints.biggest.width * 0.1,
                            // height: constraints.biggest.width * 0.1,
                            width: 55,
                            height: 55,
                            margin: EdgeInsets.all(3),
                            child: Text(
                              "${puzzle.currentValue ?? ''}".toUpperCase(),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            // alphabet btn
            width: size.width / 2.5,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 24,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool statusBtn = currentQues.puzzles
                        .indexWhere((puzzle) => puzzle.currentIndex == index) >=
                    0;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    Color color = statusBtn ? Colors.white60 : Colors.white;

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.circular((size.width / 2.5) * 0.02),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.zero,
                      child: TextButton(
                        child: Center(
                          child: Text(
                            '${currentQues.arrayBtns?[index]}'.toUpperCase(),
                            style: TextStyle(
                              color: MyColors.primary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (!statusBtn) setBtnClick(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 45,
                  color: MyColors.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  generatePuzzle({
    List<WordFindQues>? loop,
    bool next: false,
    bool left: false,
  }) {
    if (loop != null) {
      indexQues = 0;
      this.listQuestions = <WordFindQues>[];
      this.listQuestions.addAll(loop);
    } else {
      if (next && indexQues < listQuestions.length - 1)
        indexQues++;
      else if (left && indexQues > 0)
        indexQues--;
      else if (indexQues >= listQuestions.length - 1) return;

      setState(() {});

      if (this.listQuestions[indexQues].isDone) return;
    }

    WordFindQues currentQues = listQuestions[indexQues];

    setState(() {});

    final List<String?> ans = [currentQues.answer];

    final WSSettings ws = WSSettings(
      width: 24,
      height: 1,
      orientations: List.from([
        WSOrientation.horizontal,
      ]),
    );

    final WordSearch wordSearch = WordSearch();

    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(ans, ws);

    if (newPuzzle.errors.isEmpty) {
      currentQues.arrayBtns = newPuzzle.puzzle.expand((list) => list).toList();
      currentQues.arrayBtns?.shuffle();

      bool isDone = currentQues.isDone;

      if (!isDone) {
        currentQues.puzzles = List.generate(ans[0]!.split("").length, (index) {
          return WordFindChar(
            correctValue: currentQues.answer?.split("")[index],
          );
        });
      }
    }

    hintCount = 0;
    setState(() {});
  }

  generateHint() async {
    WordFindQues currentQues = listQuestions[indexQues];

    List<WordFindChar> puzzleNoHint = currentQues.puzzles
        .where((puzzle) => !puzzle.hintShow && puzzle.currentIndex == null)
        .toList();

    if (puzzleNoHint.length > 0 && hintCount < hintLimit) {
      hintCount++;
      int indexHint = Random().nextInt(puzzleNoHint.length);
      int countTemp = 0;
      print(hintCount);

      currentQues.puzzles = currentQues.puzzles.map((puzzle) {
        if (!puzzle.hintShow && puzzle.currentIndex == null) countTemp++;

        if (indexHint == countTemp - 1) {
          puzzle.hintShow = true;
          puzzle.currentValue = puzzle.correctValue;
          puzzle.currentIndex = currentQues.arrayBtns!
              .indexWhere((btn) => btn == puzzle.correctValue);
        }
        return puzzle;
      }).toList();

      if (currentQues.fieldCompleteCorrect()) {
        // ตอบข้อนั้นถูก
        corrected++;
        currentQues.isDone = true;
        print(corrected);

        if (corrected == listQuestions.length) {
          // ตอบถูกครบทุกข้อ
          print("CORRECT! GOOD JOB MATE");
          Future.delayed(
            Duration.zero,
            () => MyDialog().onAlert(
              context,
              title: "เก่งมากอั้ยต้าว!",
              content: "เก่งขนาดนี้ A ลอยมาแต่ไกลแล้ว",
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle(next: true);
      }
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<void> setBtnClick(int index) async {
    WordFindQues currentQues = listQuestions[indexQues];

    int currentIndexEmpty =
        currentQues.puzzles.indexWhere((puzzle) => puzzle.currentValue == null);

    if (currentIndexEmpty >= 0) {
      currentQues.puzzles[currentIndexEmpty].currentIndex = index;
      currentQues.puzzles[currentIndexEmpty].currentValue =
          currentQues.arrayBtns?[index];

      if (currentQues.fieldCompleteCorrect()) {
        // ตอบข้อนั้นถูก
        corrected++;
        currentQues.isDone = true;
        print(corrected);

        if (corrected == listQuestions.length) {
          // ตอบถูกครบทุกข้อ
          print("CORRECT! GOOD JOB MATE");
          Future.delayed(
            Duration.zero,
            () => MyDialog().onAlert(
              context,
              title: "เก่งมากอั้ยต้าว!",
              content: "เก่งขนาดนี้ A ลอยมาแต่ไกลแล้ว",
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle(next: true);
      }
      if (!mounted) return;
      setState(() {});
    }
  }
}

class WordFindQues {
  String? question;
  String? pathImage;
  String? answer;
  bool isDone = false;
  bool isFull = false;

  List<WordFindChar> puzzles = <WordFindChar>[];
  List<String>? arrayBtns = <String>[];

  WordFindQues({
    this.pathImage,
    this.question,
    this.answer,
    this.arrayBtns,
  });

  void setWordFindChar(List<WordFindChar> puzzles) => this.puzzles = puzzles;

  void setIsDone() => this.isDone = true;

  bool fieldCompleteCorrect() {
    bool complete =
        this.puzzles.where((puzzle) => puzzle.currentValue == null).length == 0;

    if (!complete) {
      this.isFull = false;
      return complete;
    }

    this.isFull = true;

    String answeredString =
        this.puzzles.map((puzzle) => puzzle.currentValue).join("");

    return answeredString == this.answer;
  }

  WordFindQues clone() {
    return new WordFindQues(
      answer: this.answer,
      pathImage: this.pathImage,
      question: this.question,
    );
  }
}

class WordFindChar {
  String? currentValue;
  int? currentIndex;
  String? correctValue;
  bool hintShow;

  WordFindChar({
    this.correctValue,
    this.currentIndex,
    this.hintShow = false,
  });

  getCurrentValue() {
    if (this.correctValue != null)
      return this.correctValue;
    else if (this.hintShow) return this.correctValue;
  }

  void clearValue() {
    this.currentIndex = null;
    this.currentValue = null;
  }
}
