import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  const icon = document.getElementById("icon");
  const dropdown = document.getElementById("dropdown");
  const logout = document.getElementById("logout");
  const header = document.querySelector("header");

  if (!icon || !dropdown || !logout) return;

  icon.addEventListener("click", (event) => {
    dropdown.classList.toggle("dropdown_hidden");
  });

  logout.addEventListener("click", () => {
    dropdown.classList.add("dropdown_hidden");
  });

  document.addEventListener("click", (event) => {
    if (!header.contains(event.target)) {
      dropdown.classList.add("dropdown_hidden");
    }
  });
});
