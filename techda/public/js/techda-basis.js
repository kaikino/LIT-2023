import { originalWordsList1, originalWordsList2, originalWordsList3 } from "/js/script.js";

const wordsListArray = [originalWordsList1, originalWordsList2, originalWordsList3];
  
let time = 15;
let timer;
let score = 0;
let mistakes = 0;
let word;
let originalWordsList; // word list for each game
let wordsList;

let timeLabel;
let wordLabel;
let textField;
let level;

window.onload = () => {
  const className = location.pathname.split("/").pop();
  addClassToMain(className);
  
  let selectTag = document.getElementById("level");
  if (selectTag !== null && location.pathname !== "/result") {
    selectTag.outerHTML = "<div>" + selectTag.outerHTML + "</div>";
  }

  if (location.pathname == "/game") {
    level = new URL(location.href).searchParams.get("level");
    if (!level) {
      originalWordsList = Array.from(originalWordsList1);
    } else {
      originalWordsList = Array.from(wordsListArray[level - 1]);
    }
    wordsList = Array.from(originalWordsList);
    timeLabel = document.getElementById("time");
    timeLabel.innerHTML = time;
    wordLabel = document.getElementById("word");
    textField = document.getElementById("text-field");
    textField.addEventListener("input", onChangeTextField);
    document.onkeydown = e => {
      if (e.key === "Enter") {
        checkWord();
      }
    }
    startGame();
  }

  if (location.pathname == "/result") {
    if (!sessionStorage.getItem("score")) {
      window.location.href = "/";
    } else {
      document.getElementById("score").readonly = true;
      document.getElementById("score").value = sessionStorage.getItem("score") + "pt";
      sessionStorage.removeItem("score");
      document.getElementById("mistakes").readonly = true;
      document.getElementById("mistakes").value = sessionStorage.getItem("mistakes") + "回";
      sessionStorage.removeItem("mistakes")
      if (document.getElementById("level")) {
        document.getElementById("level").readonly = true;
        document.getElementById("level").value = sessionStorage.getItem("level");
        sessionStorage.removeItem("level");
      }
      document.getElementById("name").nextElementSibling.disabled = true;
      document.getElementById("name").addEventListener("input", onChangeNameField);
    }
  }

  if (location.pathname == "/rankings") {
    setRankingTable(1);
    
    document.getElementById("level").addEventListener("change", (e) => {
      setRankingTable(e.target.value);
    });
  }
}

const startGame = () => {
  updateWord();
  timer = setInterval(updateTime, 1000);
}

const updateTime = () => {
  if (time > 1) {
    time--;
    document.getElementById("time").innerHTML = time;
  } else {
    clearInterval(timer);
    sessionStorage.setItem("score", score);
    sessionStorage.setItem("mistakes", mistakes);
    sessionStorage.setItem("level", level);
    window.location.href = "/result";
  }
}

const updateWord = () => {
  word = randomWord();
  wordLabel.innerHTML = word;
}

const randomWord = () => {
  if (wordsList.length == 0) {
    wordsList = Array.from(originalWordsList);
  }
  const randInt = getRandomInt(wordsList.length);
  return wordsList.splice(randInt, 1);
}

const getRandomInt = max => {
  return Math.floor(Math.random() * max);
}

const onChangeTextField = e => {
  const regex = /^\p{scx=Hiragana}+$/u;
  if (regex.test(e.target.value.slice(-1))) {
    e.target.blur();
    e.target.focus();
  }
}

const onChangeNameField = e => {
  const len = e.target.value.length;
  const button = e.target.nextElementSibling;
  const regex = /\s/;
  if (regex.test(e.data)) {
    e.target.value = e.target.value.replace(/\s/, "");
  } else if (len == 0 || len > 10) {
    button.disabled = true;
  } else {
    button.disabled = false;
  }
}

const checkWord = () => {
  if (isKatakana(word)) {
    word = katakanaToHiragana(word);
  }
  if (textField.value == word) {
    score++;
    updateWord();
  } else {
    mistakes++;
    textField.classList.add("shake");
    setTimeout(() => {
      textField.classList.remove("shake");
    }, 500);
  }
  textField.value = "";
}

const isKatakana = text => {
  return !!String(text).match(/^[ァ-ヶー　]*$/);
}

const katakanaToHiragana = text => {
  return String(text).replace(/[\u30a1-\u30f6]/g, match => {
    const chr = match.charCodeAt(0) - 0x60;
    return String.fromCharCode(chr);
  });
}

const addClassToMain = className => {
  if (className) {
    document.getElementById("main").classList.add(className);
  } else {
    document.getElementById("main").classList.add("home");
  }
}

const setRankingTable = (level) => {
  const tables = document.querySelectorAll("table");
  for (const table of tables) {
    table.style.visibility ="hidden";
  }
  tables[level - 1].style.visibility = "visible";
}
