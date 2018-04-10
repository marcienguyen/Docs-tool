/*jQuery function*/
$(document).ready(function(){
    $(".search-btn .fa-search").click(function(){
        $(this).hide();
        $(".fa-search-close").show();
        $(".navbar .navbar-left").hide();
        $(".navbar .search-box").show();
        $("#form-search").fadeIn();
        $("#mkdocs-search-results").fadeIn();
        $(".search-backdrop").show();
    });
    $(".search-btn .fa-search-close").click(function(){
        $(this).hide();
        $(".fa-search").show();
        $(".navbar .navbar-left").show();
        $(".navbar .search-box").hide();
        $("#form-search").hide();
        $("#mkdocs-search-results").fadeOut();
        $(".search-backdrop").fadeOut();
    });
    $(".mobile-search-btn .fa-search").click(function(){
        $(this).hide();
        $(".mobile-search-close-btn").show();
        $(".navbar .search-box").addClass('mobile').show();
        $("#form-search").fadeIn();
        $("#mkdocs-search-results").fadeIn();
        $(".search-backdrop").show();
    });
    $(".mobile-search-close-btn").click(function(){
        $(this).hide();
        $(".mobile-search-btn .fa-search").show();
        $(".navbar .search-box").removeClass('mobile').hide();
        $("#form-search").hide();
        $("#mkdocs-search-results").fadeOut();
        $(".search-backdrop").fadeOut();
    });

    /*menu*/
    $(".menu a").each(function() {
        if ($(this).next().length > 0) {
            $(this).addClass("more");
        };
    });
    /*var menux = $('.menu a.parent');
    $( '<span class="more"></span>' ).insertBefore(menux);*/
    $('.menu .more').click(function(){
        $(this).parent().toggleClass('open');
        $(this).parent('.menu').toggleClass('open');
        $(this).next('ul').toggleClass('expand');
    });
    $('.menu .sub-menu-btn').click(function(){
        $('.menu > ul').toggleClass('menu-open');
    });
    //close menu when click outside
    $('*').on('click', function(e){
        if(!$(this).hasClass('more')){
            $('.menu').removeClass('open').find('ul.expand').removeClass('expand');
            //e.stopPropagation();
            //e.preventDefault();
        } else {
            e.stopPropagation();
        };
    });
    /*end menu*/

    //protect table width
    $('.main-content div[role="main"] > table').wrap('<div class="protect-table"></div>');

    //Scroll app
    $(document).on("scroll", onScroll);

    //smoothscroll
    $('.bs-sidenav a[href^="#"]').on('click', function (e) {
        e.preventDefault();
        $(document).off("scroll");

        $('.bs-sidenav div[data-toggle="collapse"] a[href^="#"]').removeClass('active');
        $(this).addClass('active');

        var target = this.hash;
        $target = $(target);
        $('html, body').stop().animate({
            'scrollTop': $target.offset().top+2
        }, 500, 'swing', function () {
            window.location.hash = target;
            $(document).on("scroll", onScroll);
        });
    });

    //hide sidebar when have only one item
    if ($('#sideNav > ul > li > ul').length <= 0) {
        $('#sideNav').hide();
    } else {
        $('#sideNav').show();
    }

    //show hide sidebar
    $('#sideNav.bs-sidebar .sidenav-toggle').click(function(){
        if(!$(this).parent().hasClass('active')) {
            $(this).parent().addClass('active');
        } else {
            $(this).parent().removeClass('active');
        }
    });
    //hide sideNav when collapse
    $('.collapse').on('shown.bs.collapse', function () {
        //$('#sideNav.bs-sidebar .sidenav-toggle').parent().removeClass('active');
        calculateNavHeight();
    })
    $('.collapse').on('hidden.bs.collapse', function () {
        //$('#sideNav.bs-sidebar .sidenav-toggle').parent().removeClass('active');
        calculateNavHeight();
    })

    calculateNavHeight();

    //back to Top
    if ($('#back-to-top').length) {
        //fixed by window viewport
        $('#back-to-top').css({'left':($(window).width()-64)+'px', 'top':($(window).height()-64)+'px'});

        var scrollTrigger = 100, // px
            backToTop = function () {
                var scrollTop = $(window).scrollTop();
                if (scrollTop > scrollTrigger) {
                    $('#back-to-top').addClass('show');
                } else {
                    $('#back-to-top').removeClass('show');
                }
            };
        backToTop();
        $(window).on('scroll', function () {
            backToTop();
        });
        $('#back-to-top').on('click', function (e) {
            e.preventDefault();
            $('html,body').animate({
                scrollTop: 0
            }, 700);
        });
    }

});

function onScroll(event){
    var scrollPos = $(document).scrollTop();
    var wimHeight = $(window).height();
    $('ul.bs-sidenav li a:last-child').each(function () {
        var currLink = $(this);
        var refElement = $(currLink.attr("href"));
        if (refElement.position().top > scrollPos && refElement.position().top < scrollPos + wimHeight / 2) {
            $('ul.bs-sidenav li a:last-child').removeClass("active");
            currLink.addClass("active");
            return false;
        }
        else{
            //currLink.removeClass("active");
        }
    });
    
}
$('.version-magento .nav-pills li').click(function(){
    $('.version-magento .nav-pills li').removeClass('active');
    var href_id = $(this).children('a').attr('href');
    $(this).addClass('active');
    $('.slide-02 .tab-pane').removeClass('show in active');
    $(href_id).addClass('show in active');
});
function calculateNavHeight() {
    //calculate height of sidebar to fit with window height
    var sidenav = $('#sideNav .bs-sidenav');
    if (sidenav.height() + sidenav.position().top > $(window).height()) {
        var padding_bott = sidenav.height() + sidenav.position().top - $(window).height();
        if (padding_bott > 200) {
            padding_bott = 200;
        } else if (padding_bott < 50) {
            padding_bott = 50;
        }
        sidenav.css({'height': ($(window).height() - sidenav.position().top) + 'px', 'overflow-y': 'scroll', 'padding-bottom': padding_bott+'px'});
    }
}

// search 2 app
require([
    base_url + '/search/mustache.min.js',
    base_url + '/search/lunr.min.js',
    'text!../search/search-results-template.mustache',
    'text!../search/search_index.json',
], function (Mustache, lunr, results_template, data) {
    "use strict";

    function getSearchTerm()
    {
        var sPageURL = window.location.search.substring(1);
        var sURLVariables = sPageURL.split('&');
        for (var i = 0; i < sURLVariables.length; i++)
        {
            var sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] == 'q')
            {
                return decodeURIComponent(sParameterName[1].replace(/\+/g, '%20'));
            }
        }
    }

    var index = lunr(function () {
        this.field('title', {boost: 10});
        this.field('text');
        this.ref('location');
    });

    data = JSON.parse(data);
    var documents = {};

    for (var i=0; i < data.docs.length; i++){
        var doc = data.docs[i];
        doc.location = base_url + doc.location;
        index.add(doc);
        documents[doc.location] = doc;
    }

    var search = function(){

        var query = document.getElementById('mkdocs-search-query2').value;
        var search_results = document.getElementById("mkdocs-search-results-2");
        while (search_results.firstChild) {
            search_results.removeChild(search_results.firstChild);
        }

        if(query === ''){
            return;
        }

        var results = index.search(query);

        if (results.length > 0){
            for (var i=0; i < results.length; i++){
                var result = results[i];
                doc = documents[result.ref];
                doc.base_url = base_url;
                doc.summary = doc.text.substring(0, 200);
                var html = Mustache.to_html(results_template, doc);
                search_results.insertAdjacentHTML('beforeend', html);
                $('#mkdocs-search-results-2').addClass('active');
            }
        } else {
            search_results.insertAdjacentHTML('beforeend', "<p>No results found</p>");
            $('#mkdocs-search-results-2').removeClass('active');
        }

    };

    var search_input = document.getElementById('mkdocs-search-query2');

    var term = getSearchTerm();
    if (term){
        search_input.value = term;
        search();
    }

    search_input.addEventListener("keyup", search);

});
