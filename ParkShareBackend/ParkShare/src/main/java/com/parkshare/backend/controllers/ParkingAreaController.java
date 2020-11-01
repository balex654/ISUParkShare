package com.parkshare.backend.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.parkshare.backend.dao.ParkingAreaRepo;
import com.parkshare.backend.models.ParkingArea;

@RestController
public class ParkingAreaController {
	
	@Autowired
	ParkingAreaRepo rep;
	
	@RequestMapping(method = RequestMethod.POST, path = "/addParkingArea")
	public void addParkingArea(ParkingArea area) {
		rep.save(area);
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/getParkingAreas/{userID}")
	public List<ParkingArea> getParkingAreas(@PathVariable("userID") long userID) {
		return rep.getParkingAreas(userID);
	}
	
	@RequestMapping(method = RequestMethod.DELETE, path = "/removeParkingArea/{id}")
	public void removeParkingArea(@PathVariable("id") long id) {
		rep.removeParkingArea(id);
	}
}
