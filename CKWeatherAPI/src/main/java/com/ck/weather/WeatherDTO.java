package com.ck.weather;

import lombok.Data;

@Data
public class WeatherDTO {
	
	private String seq;
	private String city;
	private String observedDate;
	private String temperature;
	private String humidity;
	private String rain;
	
}
