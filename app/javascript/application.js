import "./rails-ujs"
import "@hotwired/turbo-rails"
import "controllers"
document.addEventListener("turbo:load", () => {
  const icon = document.getElementById("icon");
  const dropdown = document.getElementById("dropdown");
  const overlayRoot = document.getElementById("dropdown-overlay-root");

  if (!icon || !dropdown || !overlayRoot) return;

  // 初期は非表示
  dropdown.classList.add("dropdown_hidden");

  // オーバーレイ生成・削除用関数
  function showOverlay() {
    if (!document.getElementById("dropdown-overlay")) {
      const overlay = document.createElement("div");
      overlay.className = "dropdown-overlay";
      overlay.id = "dropdown-overlay";
      overlay.addEventListener("click", () => {
        dropdown.classList.add("dropdown_hidden");
        overlay.remove();
      });
      document.body.appendChild(overlay);
    }
  }
  function hideOverlay() {
    const overlay = document.getElementById("dropdown-overlay");
    if (overlay) overlay.remove();
  }

  // アイコンを押したら開く（トグルでOK）
  icon.addEventListener("click", (e) => {
    e.stopPropagation();
    const isOpen = dropdown.classList.toggle("dropdown_hidden");
    if (!isOpen) {
      showOverlay();
    } else {
      hideOverlay();
    }
  });

  // ドロップダウン内クリックは閉じない
  dropdown.addEventListener("click", (e) => {
    e.stopPropagation();
  });

  // 外側クリックで閉じる（ドロップダウンが開いている時のみ）
  document.addEventListener("click", () => {
    if (!dropdown.classList.contains("dropdown_hidden")) {
      dropdown.classList.add("dropdown_hidden");
      hideOverlay();
    }
  });
});

document.addEventListener("turbo:load", () => {
  const iconInput = document.getElementById("icon_input");
  const avatarPreview = document.getElementById("avatar_preview");

  if (!iconInput || !avatarPreview) return;

  iconInput.addEventListener("change", (e) => {
    const file = e.target.files && e.target.files[0];

    if (!file) {
      avatarPreview.innerHTML =
        '<span class="avatar-placeholder">PNG/JPG（クリックして選択）</span>';
      return;
    }

    const reader = new FileReader();
    reader.onload = (ev) => {
      avatarPreview.innerHTML =
        `<img src="${ev.target.result}" alt="avatar"
          style="width:100%;height:100%;object-fit:cover;border-radius:50%;">`;
    };
    reader.readAsDataURL(file);
  });
});
