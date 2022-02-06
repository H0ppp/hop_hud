$(function() {
    var $debug = $("#debug");
	var $heal = $("#heal");
	var $box = $("#box");
	var $boxArmor = $("#boxArmor");
	var $boxFuel = $("#boxFuel");
	$("#map").hide();
    $("#hud").hide();
	$("#vehicle").hide();

	window.addEventListener('message', function(event){
		var item = event.data;

		$box.css("width", (event.data.heal-100)+"%");
		$boxArmor.css("width", (event.data.armor)+"%");
		$boxFuel.css("width", (event.data.fuel)+"%");
		if (item.type === "ui") {
			if (item.display === true) {
            	$("#map").show();
                $("#hud").show();
				$("#vehicle").show();
			} else{
              	$("#map").hide();
                $("#hud").hide();
				$("#vehicle").hide();
            }
	    } else if (item.type === "vehui"){
            $('#street').text(event.data.location);
            $('#compass').text(event.data.dir);
        }
    }); 
});
