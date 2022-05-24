// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require action_cable
//= require jquery.remotipart
//= require cocoon
//= require activestorage
//= require turbolinks
//= require_tree . 


var App = App || {};
App.cable = ActionCable.createConsumer();

$(document).on('turbolinks:load', function(){
  $('a.voted-up-link').on('ajax:success', function(e){
    ratinOutput(e)
  })
  $('a.voted-up-link').on('ajax:error', function(e){
    alertOutput(e)
  })
  
  $('a.voted-down-link').on('ajax:success', function(e){
    ratinOutput(e)
  })
  $('a.voted-down-link').on('ajax:error', function(e){
    alertOutput(e)
  })

  $('a.revote-link').on('ajax:success', function(e){
    ratinOutput(e)
  })
})

function ratinOutput(e) {
  let resource = e['detail'][0]
  let object = resource.answer || resource.question
  let resourceId = object.id
  console.log(object.raiting)
  $('.raiting_' + resourceId).html(object.raiting)
  $('.revote-link').show()
}

function alertOutput(e){
  $('.alert').html(e['detail'][0])    
}
