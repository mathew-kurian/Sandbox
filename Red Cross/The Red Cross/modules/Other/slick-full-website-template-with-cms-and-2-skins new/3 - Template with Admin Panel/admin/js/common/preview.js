function XMLFormsPreviewImage(el , src){
	div = document.getElementById("preview");
	if (src == null) {
		div.style.display = "none";
	} else {
		div.innerHTML = "<img src='" + src + "'/>";
		div.style.display = "block";
	}

	var pos = getAbsolutePos(el);

	//move the preview to under the image
	div.style.left = pos.x + "px";
	div.style.top = pos.y + pos.height + 5 + "px";
}