function wordBlanks(noun, adj, verb, adv) {
    var result = "";
    result += "The " + adj + noun + verb + "to the store " + adv;
    return result;
}
console.log(wordBlanks("dog ", "big ", "ran ", "quickly "));