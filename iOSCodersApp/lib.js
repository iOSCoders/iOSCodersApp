function zoom(toScale) {
    var pt = 8 + ((16 / 7) * toScale);
    document.styleSheets[0].cssRules[0].style.fontSize = pt + "pt";
//    alert(document.styleSheets[0].cssRules[0].style.fontSize);
}
