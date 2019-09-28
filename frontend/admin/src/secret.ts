const firstWords = [
  "jazzy",
  "fuzzy",
  "muzzy",
  "north",
  "south",
  "happy",
  "green",
  "smark",
  "black",
  "other",
  "dirty",
  "sorry",
  "alive",
  "daily",
  "white",
  "sweet",
  "clear",
  "young",
  "right",
  "asian",
  "local",
  "brave",
  "solid",
  "early",
  "plain",
  "quiet",
  "lucky",
  "clean",
  "short",
  "worse",
  "heavy",
  "close",
  "small",
  "first",
  "false",
  "roman",
  "rough",
  "loose",
  "fancy",
  "fresh",
  "ready",
  "round",
  "tired",
  "nasty",
  "proud",
  "eager",
  "latin",
  "angry",
  "noble",
  "naive",
  "tough",
  "still",
  "empty",
  "sharp",
  "dutch",
  "loyal",
  "greek",
  "ample",
  "elder",
  "solar",
  "large",
  "toxic",
  "juicy",
  "thick",
  "cheap",
  "civil",
  "gross",
  "acute",
  "major",
  "drunk",
  "moral",
  "vague",
  "manly"
];

const secondWords = [
  "amber",
  "apple",
  "tiger",
  "pizza",
  "music",
  "angel",
  "party",
  "sugar",
  "river",
  "money",
  "lemon",
  "jesus",
  "china",
  "story",
  "power",
  "david",
  "april",
  "candy",
  "puppy",
  "jason",
  "pasta",
  "jacob",
  "magic",
  "jelly",
  "honor",
  "cycle",
  "zebra",
  "bully",
  "mango",
  "bible",
  "panda",
  "paris",
  "human",
  "metal",
  "henry",
  "penny",
  "honey",
  "color",
  "photo",
  "table",
  "school",
  "ocean",
  "belly",
  "eagle",
  "olive",
  "bacon",
  "simon",
  "onion",
  "video",
  "tulip",
  "angle",
  "drama",
  "movie",
  "award",
  "pluto",
  "actor",
  "baker",
  "giver",
  "focus",
  "pencil",
  "hippo",
  "noble",
  "japan",
  "woman",
  "logic",
  "email",
  "style"
];

function makeNumber(length: number) {
  var result           = '';
  var characters       = '123456789';
  var charactersLength = characters.length;
  for ( var i = 0; i < length; i++ ) {
     result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
}

export function makeCode() {
  const fi = Math.floor(Math.random() * firstWords.length);
  const si = Math.floor(Math.random() * secondWords.length);
  const n = makeNumber(5);
  let first = firstWords[fi].toLowerCase();
  let second = secondWords[si].toLowerCase();
  if (first.length !== 5) {
    first = firstWords[0];
  }
  if (second.length !== 5) {
    second = secondWords[0];
  }
  return first + '-' + second + '-' + n;
}