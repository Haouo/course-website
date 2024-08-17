document.addEventListener("DOMContentLoaded", function() {
    var links = document.querySelectorAll('a[href^="http"]');
    links.forEach(function(link) {
        link.setAttribute('target', '_blank');
    });
});
function changeFontSize(size) {
    document.body.classList.remove('small-font', 'medium-font', 'large-font');
    document.body.classList.add(size + '-font');
}