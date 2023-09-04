// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbo:load',event => {
    if(screen.width < 1280) return; // disable for mobile
    const input = document.getElementById("query")
    input.focus()
    const val = input.value;
    input.value = '';
    input.value = val;
})

