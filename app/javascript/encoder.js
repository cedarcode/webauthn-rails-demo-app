function binToStr(bin) {
  return btoa(new Uint8Array(bin).reduce(
    (s, byte) => s + String.fromCharCode(byte), ''
  ));
}

function strToBin(str) {
  console.log(str);
  return Uint8Array.from(atob(str), c => c.charCodeAt(0));
}

export { binToStr, strToBin }
