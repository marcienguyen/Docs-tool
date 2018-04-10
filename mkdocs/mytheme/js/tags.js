function reheightTags() {
    if (!(document.contains(document.getElementById("tags")))) {
        document.getElementById("sideNav").style.top= "75px";
    } else {
        var tagsHeight = document.getElementById("tags").clientHeight;
        var shiftHeight = tagsHeight + 57;
        var pickle = shiftHeight + "px";
        document.getElementById("sideNav").style.top = pickle;
    }
}

reheightTags();

window.addEventListener('resize', reheightTags);
