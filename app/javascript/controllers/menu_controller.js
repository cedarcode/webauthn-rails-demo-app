import { Controller } from "@hotwired/stimulus"
import { MDCMenu, Corner as MDCMenu_Corner } from '@material/menu';

export default class extends Controller {
  static targets = ["openable"]

  open() {
    let menu = new MDCMenu(this.openableTarget);
    menu.open = !menu.open;
    menu.setAnchorCorner(MDCMenu_Corner.BOTTOM_START);
  }
}
