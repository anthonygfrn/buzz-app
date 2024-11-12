const selectedPalette = ["#FF6F61", "#6B5B95", "#88B04B", "#F7CAC9", "#92A8D1"];

const options = {
  color: ["Text", "Highlight"],
  applyColor: ["Line", "Paragraph", "Sentence", "Punctuation"],
  lineSpacing: ["Standard", "Large", "Extra Large"],
  charSpacing: ["Standard", "Large", "Extra Large"],
  wordSpacing: ["Standard", "Large", "Extra Large"],
  font: ["SF Pro", "Arial", "Open Sans", "Open Dyslexic", "Calibri"],
  fontSize: ["Standard", "Large", "Extra Large"],
  fontWeight: ["Standard", "Bolder"],
};

const icons = {
  color: ["images/color-text.png", "images/highlight-text.png"],
  applyColor: ["images/apply-color-line.png", "images/paragraph.png", "images/sentence.png", "images/punctuation.png"],
  lineSpacing: ["images/line-spacing.png", "images/line-spacing.png", "images/line-spacing.png"],
  charSpacing: ["images/char-spacing.png", "images/char-spacing.png", "images/char-spacing.png"],
  wordSpacing: ["images/word-spacing.png", "images/word-spacing.png", "images/word-spacing.png"],
  font: ["images/sf-pro.png", "images/arial.png", "images/open-sans.png", "images/open-dislexic.png", "images/calibri.png"],
  fontSize: ["images/font-size.png", "images/font-size.png", "images/font-size.png"],
  fontWeight: ["images/font-weight.png", "images/font-weight.png"],
};

document.querySelectorAll(".arrow").forEach((arrow) => {
  arrow.addEventListener("click", (e) => {
    const type = e.target.getAttribute("data-type");
    const direction = e.target.getAttribute("data-direction");

    document.body.style.cursor = "wait";
    setTimeout(() => {
      changePicker(type, direction);
      document.body.style.cursor = "default";
    }, 100);
  });
});

document.querySelectorAll(".picker-box").forEach((pickerBox) => {
  pickerBox.addEventListener("click", () => {
    const type = pickerBox.getAttribute("data-type");
    changePicker(type, "right");
  });
});

function changePicker(type, direction) {
  const textElement = document.getElementById(`${type}Text`);
  const iconElement = document.getElementById(`${type}Icon`);

  const currentIndex = options[type].indexOf(textElement.textContent);
  const newIndex = direction === "left"
    ? (currentIndex - 1 + options[type].length) % options[type].length
    : (currentIndex + 1) % options[type].length;

  textElement.textContent = options[type][newIndex];
  iconElement.src = icons[type][newIndex];
}

document.getElementById("usePreference").addEventListener("click", () => {
  chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
    const colorMode = document.getElementById("colorText").textContent.toLowerCase();
    const applyColorOption = document.getElementById("applyColorText").textContent.toLowerCase();

    chrome.tabs.sendMessage(tabs[0].id, {
      type: colorMode === "highlight" ? "highlight" : "color",
      colors: selectedPalette,
      option: applyColorOption,
    });

    chrome.tabs.sendMessage(tabs[0].id, {
      type: "spacing",
      letterSpacing: normalizeSpacing("charSpacing"),
      lineSpacing: normalizeSpacing("lineSpacing"),
      paragraphSpacing: normalizeSpacing("wordSpacing"),
    });

    chrome.tabs.sendMessage(tabs[0].id, {
      type: "typography",
      font: normalizeTypography("font"),
      fontSize: normalizeTypography("fontSize"),
      fontWeight: normalizeTypography("fontWeight"),
    });
  });
});

function normalizeSpacing(type) {
  const value = document.getElementById(`${type}Text`).textContent.toLowerCase();
  return value === "standard" ? "standard" : value === "extra large" ? "xlarge" : "large";
}

function normalizeTypography(type) {
  const value = document.getElementById(`${type}Text`).textContent.toLowerCase().replace(" ", "-");
  return value === "standard" ? "standard" : value;
}

document.getElementById("savePreference").addEventListener("click", () => {
  console.log("Preferences saved.");
});
