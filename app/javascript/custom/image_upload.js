import { I18n } from "i18n-js";

const i18n = new I18n();

// Setup locale
i18n.defaultLocale = document.documentElement.dataset.defaultLocale || "en";
i18n.locale = document.documentElement.dataset.locale || "en";

// Load translation file
fetch("/locales.json")
  .then(response => response.json())
  .then(translations => {
    i18n.store(translations);
    window.I18n = i18n;
  })
  .catch(error => {
    console.error(" Failed to load locales.json:", error);
  });

// Attach validation once Turbo loads
document.addEventListener("turbo:load", function () {
  const localeFromPath = window.location.pathname.split("/")[1] || "en";
  i18n.locale = localeFromPath;

  const imageUpload = document.querySelector("#micropost_image");
  if (!imageUpload) return;

  imageUpload.addEventListener("change", function () {
    if (!imageUpload.files.length) return;

    const file = imageUpload.files[0];
    const maxSize = parseFloat(imageUpload.dataset.maxFileSizeMb);
    const sizeInMegabytes = file.size / 1024 / 1024;
    const allowedTypes = ["image/jpeg", "image/png", "image/gif"];

    if (!allowedTypes.includes(file.type)) {
      const typeMsg = i18n.t("errors.messages.must_be_valid_image_format");
      alert(typeMsg);
      imageUpload.value = "";
      return;
    }

    if (sizeInMegabytes > maxSize) {
      const sizeMsg =
        i18n.t("errors.messages.image_too_big", { size: maxSize });
      alert(sizeMsg);
      imageUpload.value = "";
    }
  });
});
