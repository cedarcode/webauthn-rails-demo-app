import { MDCSnackbar } from '@material/snackbar';

function showMessage(message) {
  const snackbar = new MDCSnackbar(document.querySelector(".js-messenger"))

  snackbar.labelText = message;
  snackbar.timeoutMs = 10000;
  snackbar.open();
}

export { showMessage }
