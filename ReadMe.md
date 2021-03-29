## 날씨 조회 RESTful API

### 상세

##### 1. 날씨 조회에 필요한 데이터를 생성합니다.
``` mysql
DROP TABLE tblWeather cascade constraints;
DROP TABLE tblLocation cascade constraints;
DROP SEQUENCE seqWeather;
DROP SEQUENCE seqLocation;

CREATE TABLE tblLocation (seq NUMBER PRIMARY KEY, city VARCHAR2(100) UNIQUE NOT NULL, latitude NUMBER NOT NULL, longtitude NUMBER NOT NULL);

CREATE TABLE tblWeather (
		seq NUMBER PRIMARY KEY, -- 날씨번호,
        locationSeq NUMBER NOT NULL REFERENCES tblLocation(seq), -- 지역번호
        observedDate DATE NOT NULL, -- 관측 날짜,
		temperature NUMBER NOT NULL, -- 평균 기온(섭씨),
		humidity NUMBER NOT NULL, -- 습도,
        rain NUMBER NOT NULL -- 강수확률
);

CREATE SEQUENCE seqWeather;
CREATE SEQUENCE seqLocation;

INSERT INTO tblLocation VALUES (seqLocation.nextVal, '경기도 화성시 진안동', 37.21374686550283, 127.03865820159403);
INSERT INTO tblLocation VALUES (seqLocation.nextVal, '경기도 화성시 화산동', 37.20606441157967, 127.01486973908173);

INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-23', 16, 41, 0);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-22', 15, 55, 20);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-21', 13, 90, 85);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-20', 12, 86, 50);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-19', 8, 32, 50);

INSERT INTO tblWeather VALUES (seqWeather.nextVal, 2, '2021-03-29', 23, 66, 65);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 2, '2021-03-28', 21, 70, 50);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 2, '2021-03-27', 19, 56, 30);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 2, '2021-03-26', 15, 19, 0);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 2, '2021-03-25', 17, 5, 0);
commit;
```

##### 2. 지역을 나타내는 문자열을 매개로 얻은 해당 지역의 날씨 정보 DTO의 배열을 ResponseBody()을 지정한 메서드에서 JSON으로 변환하여 전달합니다.
``` java
@Controller
public class WeatherController {

	@Autowired
	private SqlSessionTemplate template;
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list() {
		return "list";
	}
	
	@RequestMapping(value="/list/{city}", method=RequestMethod.GET)
	@ResponseBody()
	public List<WeatherDTO> getWeatherList(@PathVariable String city) {

		//pathVariable로 받은 도시명을 매개변수로, 해당 도시의 날씨 정보의 배열을 반환받습니다.
		List<WeatherDTO> list = template.selectList("weather.getWeatherList", city);
		
		return list;
	}
	
}
```
##### 3. HTML 페이지에서 위도와 경도를 담은, body에 담아 보낸 JSON 객체를 @RequestBody 어노테이션을 사용하여 DTO 객체로 받아 활용합니다.  
``` java
	@RequestMapping(value="/list/city/position", method=RequestMethod.POST)
	@ResponseBody
	public List<WeatherDTO> getWeatherListByPosition(@RequestBody LocationDTO ldto) {
		
		//@RequestBody를 사용하여 body에 보낸 JSON객체를 받습니다. 이때, DTO 객체를 매개로 명시하여 JSON 객체를 DTO 객체로 변환합니다.
		
		//클릭한 위치의 위도와 경도를 소수점 둘째자리 이하까지만 남겨 날씨를 조회할 위치의 좌표로 사용합니다.
		double simpleLat = Math.floor(Double.parseDouble(ldto.getLatitude()) * 100) / 100;
		double simpleLng = Math.floor(Double.parseDouble(ldto.getLongtitude()) * 100) / 100;

		ldto.setLatitude(String.format("%.2f", simpleLat));
		ldto.setLongtitude(String.format("%.2f", simpleLng));

		List<WeatherDTO> list = template.selectList("weather.getWeatherListByPosition", ldto);
		
		return list;
	}
	
```


##### 4. Ajax로 JSON 객체를 받아 사용하거나, 지도 클릭 시 클릭한 지역의 위도와 경도를 JSON 객체로 변환하여 컨트롤러로 보냅니다.
``` html
...
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
	
	<script>
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
		
		...
		(카카오맵 API 관련)
		
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
		...
	</script>
```
***
![result](/images/resultNew2.PNG)

> 지역 이름을 태그로 감싼 버튼을 누르거나 지도에서 특정 지역을 클릭하면 해당 지역의 날씨 정보를 보여줍니다.

![result](/images/resultNew.PNG)



