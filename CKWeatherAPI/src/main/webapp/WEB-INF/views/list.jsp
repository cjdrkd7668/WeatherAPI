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
	
</style>
</head>
<body>
	
	<h1>RESTful API 개발</h1>
	<h3>날씨 조회</h3>
	<button type="button" id="btn-weather" style="margin-bottom: 50px">경기도 화성시 진안동</button>
	
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
	
	<script>
		
		var city = "";
		var temp = "";
	
		$('#btn-weather').click(function() {
			city = $(this).text();
			
			$.ajax({
		    	type:'GET',
		        url:'/weather/list/' + city,
		        dataType: "json",
		        success: function (result) {
		        	 
		        	$(result).each(function(index, item) {
						console.log(item.seq);
						console.log(item.city);
						console.log(item.temperature);
						console.log(" ");
							
						temp = $('#add-td-here').html();
						
						temp += "<tr>";
						temp += "<td>" + item.city + "</td>";
						temp += "<td>" + item.observedDate + "</td>";
						temp += "<td>" + item.temperature + "&#8451;</td>";
						temp += "<td>" + item.humidity + "%</td>";
						temp += "<td>" + item.rain + "%</td>";
						temp += "</tr>";
						
						$('#add-td-here').html(temp);
						
		        	})
		        	
		        },
		        error: function(a,b,c) {
					console.log(a,b,c);
				}
		      
			});
			
		});
	
	</script>
	
</body>
</html>