// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "messenger"
import Rails from "@rails/ujs";
import "@rails/request.js"

Rails.start();
