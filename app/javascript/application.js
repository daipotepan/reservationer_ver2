import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  const icon = document.getElementById("icon");
  const dropdown = document.getElementById("dropdown");
  const logout = document.getElementById("logout");
  const header = document.querySelector("header");

  if (!icon || !dropdown) return;

  dropdown.classList.add("dropdown_hidden");

  icon.addEventListener("click", (event) => {
    event.stopPropagation();
    dropdown.classList.toggle("dropdown_hidden");
  });


  if (logout) {
    logout.addEventListener("click", () => {
      dropdown.classList.add("dropdown_hidden");
    });
  }

  document.addEventListener("click", (event) => {
    const clickedInsideHeader = header && header.contains(event.target);
    const clickedInsideDropdown = dropdown && dropdown.contains(event.target);
    if (!clickedInsideHeader && !clickedInsideDropdown) {
      dropdown.classList.add("dropdown_hidden");
    }
  });
});

document.addEventListener("turbo:load", () => {
  const iconInput = document.getElementById("icon_input");
  const avatarPreview = document.getElementById("avatar_preview");
  if (iconInput && avatarPreview) {
    iconInput.addEventListener("change", (e) => {
      const file = e.target.files && e.target.files[0];
      if (!file) {
        avatarPreview.innerHTML = '<span class="avatar-placeholder">PNG/JPG（クリックして選択）</span>';
        return;
      }
      const reader = new FileReader();
      reader.onload = (ev) => {
        avatarPreview.innerHTML = `<img src="${ev.target.result}" alt="avatar" style="width:100%;height:100%;object-fit:cover;border-radius:8px;">`;
      };
      reader.readAsDataURL(file);
    });

    // Clicking the label already focuses/activates the associated file input
    // Avoid programmatically calling `iconInput.click()` here to prevent
    // the file dialog from opening twice in some browsers.
  }
});