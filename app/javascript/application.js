import "@hotwired/turbo-rails"

document.addEventListener("turbo:load", () => {
  const numberInputs = document.querySelectorAll("input.number-with-comma");

  numberInputs.forEach(input => {

    if (input.value && !input.value.includes(",")) {
      input.value = Number(input.value).toLocaleString();
    }

    // フォーカス時 → カンマ除去
    input.addEventListener("focus", () => {
      input.value = input.value.replace(/,/g, "");
    });

    // フォーカス外れたとき → カンマ付け直し
    input.addEventListener("blur", () => {
      let value = input.value.replace(/,/g, "");
      if (value) {
        input.value = Number(value).toLocaleString();
      }
    });
  });
});

document.addEventListener("submit", (e) => {
  e.target.querySelectorAll("input.number-with-comma").forEach((input) => {
    input.value = input.value.replace(/,/g, "");
  });
});
