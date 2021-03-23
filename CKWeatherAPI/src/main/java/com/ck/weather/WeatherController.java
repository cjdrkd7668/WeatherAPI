package com.ck.weather;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
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
	@ResponseBody()
	public List<WeatherDTO> getWeatherList(@PathVariable String city) {

		//pathVariable로 받은 도시명을 매개변수로, 해당 도시의 날씨 정보의 배열을 반환받습니다.
		List<WeatherDTO> list = template.selectList("weather.getWeatherList", city);
		
		return list;
	}
	
	
}