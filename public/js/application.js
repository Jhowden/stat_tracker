$(document).ready(function() {
  $('.add_fields').click(function(event){

   	event.preventDefault();
    var time = new Date().getTime();
    var regexp = new RegExp( $( this ).data( "id" ), "g" );
    $( this ).before( $( this ).attr( "data" ).replace( Math.random(), time ) );
  }); 
});