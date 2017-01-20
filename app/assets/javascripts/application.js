// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require wow
//= require jquery
//= require jquery_ujs
//= require tether
//= require bootstrap
//= require turbolinks
//= require_tree .

new WOW().init();

$(document).on('turbolinks:load', function () {
    var fn = function () {
        $this = $(this);
        var group = $this.parents('.form-group:first');

        var focused = $this.is(':focus');
        group.toggleClass('form-group-focused', focused);
        group.toggleClass('form-group-empty', !(focused || $this.val().length));
    };

    var inputs = $('input[type="text"].form-control');
    inputs.each(fn);
    inputs.on('input focus blur', fn);
});
