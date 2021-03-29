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

INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-23', 16, 41, 0);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-22', 15, 55, 20);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-21', 13, 90, 85);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-20', 12, 86, 50);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-19', 8, 32, 50);
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

##### 3. Ajax로 JSON 객체를 받아 사용합니다.
``` html
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
```
***
![result](/images/result.PNG)

> 지역 이름을 태그로 감싼 버튼을 누르면 날씨 정보를 보여줍니다.

![result](/images/result2.PNG)



