chrome.runtime.onMessage.addListener((request) => {
  if (request.type === "color") {
    resetColors();
    applyColor(getColorPalette("color"), request.option);
  } else if (request.type === "highlight") {
    resetColors();
    applyHighlight(getColorPalette("highlight"), request.option);
  } else if (request.type === "spacing") {
    applySpacing(request.letterSpacing, request.lineSpacing, request.paragraphSpacing);
  } else if (request.type === "typography") {
    applyTypography(request.font, request.fontSize, request.fontWeight);
  }
});

function applyColor(colors, option) {
  let colorIndex = 0;
  document.querySelectorAll("p").forEach((paragraph) => {
    const parts = splitTextByOption(paragraph, option);
    paragraph.innerHTML = parts
      .map(
        (part) =>
          `<span style="color: ${colors[colorIndex++ % colors.length]}; ${
            option === "line" ? "display: inline;" : ""
          }">${part}</span>`
      )
      .join(option === "paragraph" ? "<br><br>" : " ");
  });
}

function applyHighlight(colors, option) {
  let colorIndex = 0;
  document.querySelectorAll("p").forEach((paragraph) => {
    const parts = splitTextByOption(paragraph, option);
    paragraph.innerHTML = parts
      .map(
        (part) =>
          `<span style="background-color: ${colors[colorIndex++ % colors.length]}; ${
            option === "line" ? "display: inline;" : ""
          } padding: 0 2px;">${part}</span>`
      )
      .join(option === "paragraph" ? "<br><br>" : " ");
  });
}

function resetColors() {
  document.querySelectorAll("p").forEach((paragraph) => {
    paragraph.innerHTML = paragraph.textContent;
  });
}

function applySpacing(letterSpacing, lineSpacing, paragraphSpacing) {
  if (letterSpacing === "standard" && lineSpacing === "standard" && paragraphSpacing === "standard") {
    resetSpacing();
  } else {
    const spacingValues = {
      standard: "normal",
      large: "0.12em",
      xlarge: "0.2em",
    };

    const lineHeightValues = {
      standard: "normal",
      large: "1.5",
      xlarge: "2",
    };

    const paragraphSpacingValues = {
      standard: "1em",
      large: "1.5em",
      xlarge: "2em",
    };

    document.querySelectorAll("p").forEach((paragraph) => {
      paragraph.style.letterSpacing = spacingValues[letterSpacing] || "normal";
      paragraph.style.lineHeight = lineHeightValues[lineSpacing] || "normal";
      paragraph.style.marginBottom = paragraphSpacingValues[paragraphSpacing] || "1em";
    });
  }
}

function resetSpacing() {
  document.querySelectorAll("p").forEach((paragraph) => {
    paragraph.style.letterSpacing = "normal";
    paragraph.style.lineHeight = "normal";
    paragraph.style.marginBottom = "1em";
  });
}

function applyTypography(font, fontSize, fontWeight) {
  const fontMapping = {
    "sf-pro": '"SF Pro", sans-serif',
    arial: "Arial, sans-serif",
    "open-sans": '"Open Sans", sans-serif',
    "open-dyslexic": '"Open Dyslexic", sans-serif',
    calibri: "Calibri, sans-serif",
  };

  document.querySelectorAll("p").forEach((paragraph) => {
    paragraph.style.fontFamily = fontMapping[font] || "sans-serif";
    
    // Apply distinct font sizes based on the normalized names
    if (fontSize === "standard") {
      paragraph.style.fontSize = "16px";
    } else if (fontSize === "large") {
      paragraph.style.fontSize = "24px";
    } else if (fontSize === "xlarge") {
      paragraph.style.fontSize = "32px";
    }
    
    paragraph.style.fontWeight = fontWeight === "bolder" ? "bolder" : "normal";
  });
}

function splitTextByOption(paragraph, option) {
  switch (option) {
    case "line":
      return splitByLine(paragraph);
    case "paragraph":
      return [paragraph.textContent];
    case "sentence":
      return paragraph.textContent.match(/[^.!?]+[.!?]*/g) || [];
    case "punctuation":
      return paragraph.textContent.split(/([.,!?;:])/).filter(Boolean);
    default:
      return [paragraph.textContent];
  }
}

function splitByLine(paragraph) {
  const words = paragraph.textContent.split(" ");
  let currentLine = "";
  const lines = [];

  const tempSpan = document.createElement("span");
  tempSpan.style.visibility = "hidden";
  tempSpan.style.position = "absolute";
  document.body.appendChild(tempSpan);

  words.forEach((word) => {
    tempSpan.textContent = currentLine + " " + word;
    if (tempSpan.offsetWidth > paragraph.clientWidth) {
      lines.push(currentLine.trim());
      currentLine = word;
    } else {
      currentLine += " " + word;
    }
  });

  if (currentLine) {
    lines.push(currentLine.trim());
  }

  document.body.removeChild(tempSpan);
  return lines;
}

function isDarkMode() {
  return window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
}

function getColorPalette(type) {
  if (type === "highlight") {
    return isDarkMode()
      ? ["#AA695E", "#699389", "#AC7C52", "#4870A3", "#B7A570"]
      : ["#E2C5C5", "#CAE2C5", "#D0C5E2", "#E2D9C5", "#C5D3E2"];
  } else {
    return isDarkMode()
      ? ["#EF8876", "#BBF0E4", "#F2A55F", "#64A0F0", "#D6CA86"]
      : ["#6F0909", "#186208", "#3E1089", "#855D06", "#114C8C"];
  }
}
