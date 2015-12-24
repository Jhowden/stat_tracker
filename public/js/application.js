$(document).ready(function() {
  $( 'body' ).on( "click", '.add_fields', function(event){
   	event.preventDefault();
    var time = new Date().getTime();
    $( this ).before( $( this ).attr( "data" ).replace( Math.random(), time ) );
  }); 
});