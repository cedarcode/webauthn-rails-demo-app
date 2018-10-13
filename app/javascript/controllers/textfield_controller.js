import { Controller } from "stimulus"
import { MDCTextField } from '@material/textfield';

export default class extends Controller {
  connect() {
    new MDCTextField(this.element);
  }
}
