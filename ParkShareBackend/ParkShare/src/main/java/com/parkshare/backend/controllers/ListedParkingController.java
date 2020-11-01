package com.parkshare.backend.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.parkshare.backend.dao.ListedParkingRepo;
import com.parkshare.backend.models.ListedParking;

@RestController
public class ListedParkingController {
	
	@Autowired
	ListedParkingRepo rep;
	
	@RequestMapping(method = RequestMethod.POST, path = "/addListedParking")
	public void addListedParking(ListedParking parking) {
		rep.save(parking);
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/getUserListedParking/{userID}")
	public List<Map<String, Object>> getUserListedParking(@PathVariable("userID") long userID) {
		return rep.getUserListedParking(userID);
	}
}
