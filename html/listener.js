$(function() {
    var $debug = $("#debug");
	var $heal = $("#heal");
	var $box = $("#box");
	var $boxArmor = $("#boxArmor");
	$("#map").hide();
    $("#car").hide();

	window.addEventListener('message', function(event){
		var item = event.data;

		$box.css("width", (event.data.heal-100)+"%");
		$boxArmor.css("width", (event.data.armor)+"%");
		if (item.type === "ui") {
			if (item.display === true) {
            	$("#map").show();
                $("#car").show();
			} else{
              	$("#map").hide();
                $("#car").hide();
            }
	    } else if (item.type === "vehui"){
            $('#street').text(event.data.location);
            $('#compass').text(event.data.dir);
        }
    }); 
});
