$(function() {
	var $container = $("#container");
	var $boxHealth = $("#box");
	var $boxFood = $("#boxFood");
	var $boxWater = $("#boxWater");
	var $boxFuel = $("#boxFuel");
	var $boxNos = $("#boxNos");

    $("#hud").hide();
	$("#vehicle").hide();
	$('#notification').hide();

	window.addEventListener('message', function(event){
		var item = event.data;
		switch (item.type) {
            case "ui":
				if (item.display === true) {
					$('#notification').css("bottom", "22%");
					$("#hud").fadeIn(500);
					$("#vehicle").fadeIn(500);
				} else{
					$('#notification').css("bottom", "5%");
					$("#hud").fadeOut(500);
					$("#vehicle").fadeOut(500);
				}
            break;

            case "vehui":
				$('#street').text(item.location);
				$('#compass').text(item.dir);
            break;

			case "cashui":
				if (item.showCash === true) {
					$("#money").fadeIn(500);
				} else{
					  $("#money").fadeOut(500);
				}
			break;

			case "pause":
				if (item.showHUD === true) {
					$container.hide();
				} else{
					$container.show();
				}
			break;

			case "notification":
				notify(item.title, item.content, item.delay);
			break;

            default:
                $boxHealth.css("width", (item.heal-100)+"%");
				$boxFood.css("width", (item.food)+"%");
				$boxWater.css("width", (item.water)+"%");
				$boxFuel.css("width", (item.fuel)+"%");
				$boxNos.css("width", (item.nos/20)+"%");
				$('#bank').text(item.bank);
				$('#cash').text(item.cash);
            break;
        }
    }); 
});

function notify(title, content, delay) {
	$('#notifTitle').html(title);
	$('#notifContent').html(content);
	$('#notification').fadeIn(200);
	setTimeout(() => {  $('#notification').fadeOut(200); }, delay);
	setTimeout(() => {  notifySuccess(); }, delay+200);
	setTimeout(() => {  return true; }, delay+200);
 }

 function notifySuccess() {
	fetch(`https://${GetParentResourceName()}/notifySuccess`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json; charset=UTF-8',
		},
		body: JSON.stringify({
			itemId: 'success'
		})
		}).then(resp => resp.json());
}