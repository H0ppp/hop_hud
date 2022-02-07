$(function() {
    var $debug = $("#debug");
	var $heal = $("#heal");
	var $box = $("#box");
	var $boxFood = $("#boxFood");
	var $boxWater = $("#boxWater");
	var $boxFuel = $("#boxFuel");
	var $boxNos = $("#boxNos");
	$("#map").hide();
    $("#hud").hide();
	$("#vehicle").hide();

	window.addEventListener('message', function(event){
		var item = event.data;

		$box.css("width", (event.data.heal-100)+"%");
		$boxFood.css("width", (event.data.food)+"%");
		$boxWater.css("width", (event.data.water)+"%");
		$boxFuel.css("width", (event.data.fuel)+"%");
		$boxNos.css("width", (event.data.nos/20)+"%");
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
