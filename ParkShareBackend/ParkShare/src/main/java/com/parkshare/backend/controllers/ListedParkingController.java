package com.parkshare.backend.controllers;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.parkshare.backend.dao.ListedParkingRepo;
import com.parkshare.backend.dao.VehicleRentedAreaRepo;
import com.parkshare.backend.models.ListedParking;
import com.parkshare.backend.models.VehicleRentedArea;

@RestController
public class ListedParkingController {
	
	@Autowired
	ListedParkingRepo rep;
	
	@Autowired
	VehicleRentedAreaRepo relationRep;
	
	@RequestMapping(method = RequestMethod.POST, path = "/addListedParking")
	public void addListedParking(ListedParking parking) {
		rep.save(parking);
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/getUserListedParking/{userID}")
	public List<Map<String, Object>> getUserListedParking(@PathVariable("userID") long userID) throws ParseException {
		
		// Get rows, find ones with end_time less than current_time, delete these rows
		List<Map<String, Object>> rows = rep.getUserListedParking(userID);
		List<Map<String, Object>> outdated = findOutdatedRows(rows);
		
		for (Map<String, Object> delete : outdated) {
			rep.deleteListedParking(((BigInteger) delete.get("id")).longValue());
		}
		
		return rep.getUserListedParking(userID);
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/getAllListedParking/{userID}")
	public List<Map<String, Object>> getAllListedParking(@PathVariable("userID") long userID) {
		
		// Get rows, find ones with end_time less than current_time, delete these rows
		List<Map<String, Object>> rows = rep.getAllListedParking(userID);
		List<Map<String, Object>> outdated = findOutdatedRows(rows);
		
		for (Map<String, Object> delete : outdated) {
			rep.deleteListedParking(((BigInteger) delete.get("id")).longValue());
		}
		
		return rep.getAllListedParking(userID);
	}
	
	@RequestMapping(method = RequestMethod.PUT, path = "/updateNumSpots/{id}/{spotsTaken}")
	public void updateNumSpots(@PathVariable("id") long id, @PathVariable("spotsTaken") int spotsTaken) {
		rep.updateNumSpots(id, spotsTaken);
	}
	
	@RequestMapping(method = RequestMethod.POST, path = "/userRentedArea/{listedAreaId}")
	public void userRentedArea(@RequestBody List<Long> vehicleIds, @PathVariable("listedAreaId") long listedAreaId) {
		for (Long id : vehicleIds) {
			VehicleRentedArea relation = new VehicleRentedArea(id, listedAreaId);
			relationRep.save(relation);
		}
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/getVehiclesInArea/{listedAreaId}")
	public List<Map<String, Object>> getVehiclesInArea(@PathVariable("listedAreaId") long listedAreaId) {
		return rep.getVehiclesInArea(listedAreaId);
	}
	
	public static List<Map<String, Object>> findOutdatedRows(List<Map<String, Object>> rows) {
		List<Map<String, Object>> outdated = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> row : rows) {
			Timestamp endTimestamp = (Timestamp) row.get("end_time");
			endTimestamp.setTime(endTimestamp.getTime() + 21600000);
			Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
			if (currentTimestamp.after(endTimestamp)) {
				outdated.add(row);
			}
		}
				
		return outdated;
	}
}
