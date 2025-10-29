// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

document.addEventListener("turbo:load", () => {
  const numberInputs = document.querySelectorAll("input.number-with-comma");

  numberInputs.forEach(input => {
    input.addEventListener("blur", () => {
      let value = input.value.replace(/,/g, "");
      if (value) {
        input.value = Number(value).toLocaleString();
      }
    });

    input.addEventListener("focus", () => {
      input.value = input.value.replace(/,/g, "");
    });
  });
});