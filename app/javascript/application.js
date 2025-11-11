import "@hotwired/turbo-rails"
import "controllers"
import $ from "jquery"

document.addEventListener("turbo:load", () => {
  // アイコンクリックでドロップダウン表示・非表示切り替え
  $("#icon").off("click").on("click", function() {
    $("#dropdown").toggleClass("dropdown_hidden");
  });

  // ドロップダウンのログアウトクリックで閉じる
  $("#logout").off("click").on("click", function() {
    $("#dropdown").addClass("dropdown_hidden");
  });

  $(document).on("click", function(event) {
    if (!$(event.target).closest("header").length) {
      $("#dropdown").addClass("dropdown_hidden");
    }
  });
});
