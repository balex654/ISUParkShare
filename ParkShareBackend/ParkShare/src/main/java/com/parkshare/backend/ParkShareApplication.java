package com.parkshare.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class ParkShareApplication {

	public static void main(String[] args) {
		SpringApplication.run(ParkShareApplication.class, args);
	}
	
	@RequestMapping(method=RequestMethod.GET, value="/hello")
	public String hello() {
		return "Hello";
	}
}
