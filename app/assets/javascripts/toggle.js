$("a[data-toggle]").on("click", function(e) {
  e.preventDefault();  // prevent navigating
  var selector = $(this).data("toggle");  // get corresponding element
  $(".toilet-info").hide();
  $(selector).show( "slow" );
});
