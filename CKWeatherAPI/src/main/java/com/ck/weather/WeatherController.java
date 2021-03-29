package com.ck.weather;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class WeatherController {

	@Autowired
	private SqlSessionTemplate template;
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list() {
		return "list";
	}
	
	@RequestMapping(value="/list/{city}", method=RequestMethod.GET)
	@ResponseBody
	public List<WeatherDTO> getWeatherList(@PathVariable String city) {

		//pathVariable로 받은 도시명을 매개변수로, 해당 도시의 날씨 정보의 배열을 반환받습니다.
		List<WeatherDTO> list = template.selectList("weather.getWeatherList", city);
		
		return list;
	}
	
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
	
	
}