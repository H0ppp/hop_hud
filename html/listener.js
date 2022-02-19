$(function() {
	var $container = $("#container");
	var $box = $("#box");
	var $boxFood = $("#boxFood");
	var $boxWater = $("#boxWater");
	var $boxFuel = $("#boxFuel");
	var $boxNos = $("#boxNos");

    $("#hud").hide();
	$("#vehicle").hide();
	$('#notification').hide();

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
				$('#notification').css("bottom", "22%");
                $("#hud").fadeIn(500);
				$("#vehicle").fadeIn(500);
			} else{
				$('#notification').css("bottom", "5%");
                $("#hud").fadeOut(500);
				$("#vehicle").fadeOut(500);
            }
	    } else if (item.type === "vehui"){
            $('#street').text(event.data.location);
            $('#compass').text(event.data.dir);
        } else if (item.type === "cashui"){
			if (item.showCash === true) {
            	$("#money").fadeIn(500);
			} else{
              	$("#money").fadeOut(500);
            }
        } else if (item.type === "pause"){
			if (item.showHUD === true) {
            	$container.hide();
			} else{
				$container.show();
            }
		} else if (item.type == "notification"){
			notify(item.title, item.content, item.delay);
		}
    }); 
});

function notify(title, content, delay) {
	$('#notifTitle').html(title);
	$('#notifContent').html(content);
	$('#notification').fadeIn(200);
	setTimeout(() => {  $('#notification').fadeOut(200); }, delay);
	setTimeout(() => {  console.log("success"); }, delay);
	setTimeout(() => {  return true; }, delay+200);
 }