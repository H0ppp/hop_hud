$(function() {
	var $container = $("#container");
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

		$box.css("width", (item.heal-100)+"%");
		$boxFood.css("width", (item.food)+"%");
		$boxWater.css("width", (item.water)+"%");
		$boxFuel.css("width", (item.fuel)+"%");
		$boxNos.css("width", (item.nos/20)+"%");
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
