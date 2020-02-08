document.addEventListener('turbolinks:load', function(){
  // Tooltip
  $('.clipboard-btn').tooltip({
    trigger: 'click',
    placement: 'top'
  });

  function setTooltip(btn, message) {
    $(btn).tooltip('show')
      .attr('data-original-title', message)
      .tooltip('show');
  }

  function hideTooltip(btn) {
    setTimeout(function() {
      $(btn).tooltip('hide');
    }, 1000);
  }

  // Clipboard
  var clipboard = new Clipboard('.clipboard-btn');

  clipboard.on('success', function(e) {
    setTooltip(e.trigger, 'Copied!');
    hideTooltip(e.trigger);
  });

  clipboard.on('error', function(e) {
    setTooltip(e.trigger, 'Failed!');
    hideTooltip(e.trigger);
  });
});
