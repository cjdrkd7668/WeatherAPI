<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.4.1.min.js"></script>
<style>

	table {
	border: 1px solid #888;
	}

	th, td {
		width: 200px;
		border-left: 1px solid #888;
		border-right: 1px solid #888;
	}
	
	td {
	background-color: #EEE;
	}
	
	.btn-weather {
		margin-top: 20px;
	}
	
	.container-map {
		width: 1200px;
	}
	
</style>
</head>
<body>
	
	<h1>RESTful API 개발</h1>
	<h3>날씨 조회</h3>
	
	<p>지도에서 날씨를 조회하고자 하는 지역을 클릭하시면 해당 지역의 날씨를 조회합니다.</p>
	<div class="container-map">
	<div id="map" style="width:100%;height:350px;"></div>
	</div>
	
	<button type="button" class="btn-weather" style="margin-bottom: 50px">경기도 화성시 진안동</button>
	<button type="button" class="btn-weather" style="margin-bottom: 50px">경기도 화성시 화산동</button>
	
	<table>
		<thead>
			<tr>
				<th>지역</th>
				<th>날짜</th>
				<th>온도</th>
				<th>습도</th>
				<th>강수확률</th>
			</tr>
		</thead>
		<tbody id="add-td-here">
		</tbody>
	</table>
	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2810d4d4cb7f396857bb6d6a768c3959"></script>
	<script>

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(37.210720030356406, 127.03962580974567), // 지도의 중심좌표
			level : 6
		// 지도의 확대 레벨
		};

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		
		var marker = new kakao.maps.Marker({ 
		    // 지도 중심좌표에 마커를 생성합니다 
		    //position: map.getCenter() 
		}); 
		// 지도에 마커를 표시합니다
		marker.setMap(map);

		// 지도에 클릭 이벤트를 등록합니다
		// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
		    
		    // 클릭한 위도, 경도 정보를 가져옵니다 
		    var latlng = mouseEvent.latLng; 
		    
		    // 마커 위치를 클릭한 위치로 옮깁니다
		    marker.setPosition(latlng);
		    
		    let cityPosition = {"latitude": latlng.getLat(), "longtitude": latlng.getLng()};
		    
		    // 컨트롤러에 json 데이터를 보냅니다.
		    $.ajax({
		    	type: 'POST',
		    	url: '/weather/list/city/position',
		    	data: JSON.stringify(cityPosition),
		    	dataType: "json",
		    	contentType: "application/json",
		    	success: function(result) {

					$('#add-td-here').html('');
		    		
					$(result).each(function(index, item) {

						writeWeather(item);

					})
					
		    	},
		    	error: function(a, b, c) {
		    		console.log(a, b, c);
		    	}
		    })
		    
		});
		
		var city = "";
		var temp = "";

		$('.btn-weather').click(function() {
			city = $(this).text();

			$.ajax({
				type : 'GET',
				url : '/weather/list/' + city,
				dataType : "json",
				success : function(result) {
					
					$('#add-td-here').html('');
					
					$(result).each(function(index, item) {
						
						writeWeather(item);

					})

				},
				error : function(a, b, c) {
					console.log(a, b, c);
				}

			});

		});
		
		// 날씨 정보를 나타내는 테이블의 열에 해당하는 태그를 동적으로 생성하는 함수
		function writeWeather(item) {

			temp = $('#add-td-here').html();

			temp += "<tr>";
			temp += "<td>" + item.city + "</td>";
			temp += "<td>" + item.observedDate + "</td>";
			temp += "<td>" + item.temperature + "&#8451;</td>";
			temp += "<td>" + item.humidity + "%</td>";
			temp += "<td>" + item.rain + "%</td>";
			temp += "</tr>";

			$('#add-td-here').html(temp);
			
		}
		
	</script>
	
</body>
</html>