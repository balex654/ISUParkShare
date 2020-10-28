package com.parkshare.backend.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.parkshare.backend.dao.UserVehiclesRepo;
import com.parkshare.backend.models.UserVehicles;

@RestController
public class UserVehiclesController {

	@Autowired
	UserVehiclesRepo rep;
	
	@RequestMapping(method = RequestMethod.POST, path = "/addVehicle")
	public void addVehicle(UserVehicles vehicle) {
		rep.save(vehicle);
	}
	
	
	@RequestMapping(method = RequestMethod.GET, path = "/getUserVehicles/{userID}")
	public List<UserVehicles> getUserVehicles(@PathVariable("userID") long userID) {
		return rep.getUserVehicles(userID);
	}
	
	@RequestMapping(method = RequestMethod.DELETE, path = "/removeVehicle/{id}")
	public void removeVehicle(@PathVariable("id") long id) {
		rep.removeVehicle(id);
	}
}
