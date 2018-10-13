/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker')

var Turbolinks = require("turbolinks")
Turbolinks.start()

import Rails from 'rails-ujs';
Rails.start()

import { MDCMenu, Corner as MDCMenu_Corner } from '@material/menu';
import { MDCTextField } from '@material/textfield';

document.addEventListener("DOMContentLoaded", function(event) {
  document.querySelectorAll(".mdc-text-field").forEach(function(textfield) {
    new MDCTextField(textfield);
  });

  let menuElement = document.querySelector(".js-menu");
  let menuOpenerElement = document.querySelector(".js-menu-opener");

  if (menuElement && menuOpenerElement) {
    let menu = new MDCMenu(menuElement);

    menuOpenerElement.addEventListener('click', function(event) {
      menu.open = !menu.open;
    });

    menu.setAnchorCorner(MDCMenu_Corner.BOTTOM_START);
  }
});
