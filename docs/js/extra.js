/*jQuery function*/
$(document).ready(function(){
    $(".fa-search").click(function(){
        $(this).hide();
        $(".fa-search-close").show();
        $(".navbar .navbar-left").hide();
        $("#form-search").fadeIn();
        $("#mkdocs-search-results").fadeIn();
        $(".search-backdrop").show();
    });
    $(".fa-search-close").click(function(){
        $(this).hide();
        $(".fa-search").show();
        $(".navbar .navbar-left").show();
        $("#form-search").hide();
        $("#mkdocs-search-results").fadeOut();
        $(".search-backdrop").fadeOut();
    });
});