export function removeSuffix(word: string, suffix: string, callback?: (word: string) => void) {
  if (word.length < suffix.length) {
    return word;
  }
  if (word.slice(-suffix.length) == suffix) {
    const out = word.slice(0, -suffix.length);
    if (callback) {
      callback(out);
    }
    return out;
  }
  return word;
}
