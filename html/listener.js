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
		$('#bank').text(event.data.bank);
		$('#cash').text(event.data.cash);
		if (item.type === "ui") {
			if (item.display === true) {
            	$("#map").fadeIn(500);
                $("#hud").fadeIn(500);
				$("#vehicle").fadeIn(500);
			} else{
              	$("#map").fadeOut(500);
                $("#hud").fadeOut(500);
				$("#vehicle").fadeOut(500);
            }
	    } else if (item.type === "vehui"){
            $('#street').text(event.data.location);
            $('#compass').text(event.data.dir);
        }
    }); 
});
