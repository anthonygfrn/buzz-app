chrome.runtime.onMessage.addListener((request) => {
  if (request.type === "color") {
    applyColor(request.colors, request.option);
  } else if (request.type === "highlight") {
    applyHighlight(request.colors, request.option);
  } else if (request.type === "spacing") {
    applySpacing(request.letterSpacing, request.lineSpacing, request.paragraphSpacing);
  } else if (request.type === "typography") {
    applyTypography(request.font, request.fontSize, request.fontWeight);
  }
});

function applyColor(colors, option) {
  let colorIndex = 0;

  resetColors(); // Clear any previously applied colors

  document.querySelectorAll("p").forEach((paragraph) => {
    const parts = splitTextByOption(paragraph, option);
    paragraph.innerHTML = parts
      .map((part) => `<span style="color: ${colors[colorIndex++ % colors.length]}">${part}</span>`)
      .join(option === "line" ? "<br>" : "");
  });
}

function applyHighlight(colors, option) {
  let colorIndex = 0;

  resetColors(); // Clear any previously applied highlights

  document.querySelectorAll("p").forEach((paragraph) => {
    const parts = splitTextByOption(paragraph, option);
    paragraph.innerHTML = parts
      .map((part) => `<span style="background-color: ${colors[colorIndex++ % colors.length]}">${part}</span>`)
      .join(option === "line" ? "<br>" : "");
  });
}

function resetColors() {
  document.querySelectorAll("p").forEach((paragraph) => {
    paragraph.innerHTML = paragraph.textContent; // Remove any spans for coloring/highlighting
  });
}

function applySpacing(letterSpacing, lineSpacing, paragraphSpacing) {
  const spacingValues = {
    standard: "normal",
    large: "1.5px",
    xlarge: "2px",
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
    paragraph.style.fontSize = fontSize === "large" ? "18px" : fontSize === "xlarge" ? "20px" : "16px";
    paragraph.style.fontWeight = fontWeight === "bold" ? "bold" : "normal";
  });
}

function splitTextByOption(paragraph, option) {
  switch (option) {
    case "line":
      return splitByLine(paragraph);
    case "paragraph":
      return [paragraph.textContent]; // Apply one color for the whole paragraph
    case "sentence":
      return paragraph.textContent.match(/[^.!?]+[.!?]*/g) || []; // Split by sentence
    case "punctuation":
      return paragraph.textContent.split(/([.,!?;:])/).filter(Boolean); // Split punctuation
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
      currentLine = word; // Start new line
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
