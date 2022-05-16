var warningVisible, oldWarning;

$(document).ready(function() {
	oldWarning = "none";
	warningVisible = "none";

    $("#hud").hide();
	$("#vehicle").hide();
	$('#notification').hide();
	$("#container").hide();
	$("#change").hide();

	var alert = new Howl({src: ['alert.wav'], volume: 0.1});

	window.addEventListener('message', function(event){
		var item = event.data;
		switch (item.type) {
			case "Visible":
				if (item.showHUD === true) {
					$("#container").show();
				} else{
					$("#container").hide();
				}
			break;
			case "CashVisible":
				if (item.showCash === true) {
					$("#money").fadeIn(500);
				} else{
					$("#money").fadeOut(500);
				}
			break;
            case "VehDataVisible":
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
            case "VehData":
				$('#street').text(item.location);
				$('#compass').text(item.dir);
            break;
			case "PlayerInfo":
				$("#boxHealth").css("width", (item.heal-100)+"%");
				$("#boxFood").css("width", (item.food)+"%");
				$("#boxWater").css("width", (item.water)+"%");
				oldCash = $('#cash').text();
				$('#cash').text(item.cash).trigger("change");
			break;
			case "VehicleInfo":
				$("#boxFuel").css("width", (item.fuel)+"%");
				$("#boxNos").css("width", (item.nos/20)+"%");
				Vehiclehealth(item.health);
				if(warningVisible != oldWarning){
					if(warningVisible != "none") {alert.play();}
				}
			break;
            default:
				console.log("Impossible event was received!");
            break;
        }
    }); 

	$("#cash").change(function() {
		if(oldCash !=  $('#cash').text()){
			var numOld = parseInt(oldCash.replace(',', '').replace('$', ''));
			var numNew = parseInt($('#cash').text().replace(',', '').replace('$', ''));
			var diff = numNew - numOld;
			if(!isNaN(diff)){
				if(diff > 0){
					$("#change").css("color", "green");
					$("#change").text("+"+diff);
				} else {
					$("#change").css("color", "red");
					$("#change").text(diff);
				}
				$("#change").show();
				setTimeout(() => {  $("#change").hide(); }, 4000);
			}
		}
	});
});

function Vehiclehealth(val){
	oldWarning = warningVisible;
	if(val > 500){
		warningVisible = "none";
		$("#yellow").hide();
		$("#red").hide();
	}else if (val > 320 && val < 601){
		warningVisible = "yellow";
		$("#red").hide();
		$("#yellow").show();
	} else if (val < 321) {
		warningVisible = "red";
		$("#yellow").hide();
		$("#red").show();
	}
}
