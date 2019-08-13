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
//= require activestorage
//= require turbolinks
//= require_tree .
//= require select2
//= require select2-full
//= require materialize

document.addEventListener('turbolinks:load', function(){
  $('.js-searchable').select2({
    width: '100%'
  });

  const members = document.querySelectorAll('.member');
  const forms = document.querySelectorAll('.member-form');

  for(const member of members) {
    member.addEventListener('click', function(){
      if (forms[0].value != '' && forms[1].value != '' && forms[2].value != '')
        return

      member.classList.add('selected-row');

      noDisplayMember();

      var form = emptyForm();

      var name = member.children[0];
      form.value = name.textContent;

      form.addEventListener('click', function(){
        form.value = '';
        member.classList.remove('selected-row');
        noDisplayMember();
      });
    });
  }

  // どのメンバーを表示しないか
  function noDisplayMember(){
    var selectedRows = document.querySelectorAll('.selected-row');
    var selected_projects = Array
      .from(selectedRows)
      .map(row => row.children[1].textContent.split(','))
      .flat()
      .filter(n => n != '');

    for(const member of members) {
      member.classList.remove('unselectable-row');
      var arr = member.children[1].textContent.split(',');
      if (intersection(arr, selected_projects).size != 0)
        member.classList.add('unselectable-row');
    }
  }

  function intersection(arr1, arr2){
    var set1 = new Set(arr1);
    var set2 = new Set(arr2);
    return new Set([...set1].filter(e => (set2.has(e))));
  }

  function emptyForm(){
    if (forms[0].value == ''){
      return forms[0];
    } else if (forms[1].value == '') {
      return forms[1];
    } else if (forms[2].value == '') {
      return forms[2];
    }
  }
});
