package com.parkshare.backend.controllers;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
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
	public List<Map<String, Object>> getUserListedParking(@PathVariable("userID") long userID) throws ParseException {
		
		// Get rows, find ones with end_time less than current_time, delete these rows
		List<Map<String, Object>> rows = rep.getUserListedParking(userID);
		List<Map<String, Object>> outdated = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> row : rows) {
			Timestamp endTimestamp = (Timestamp) row.get("end_time");
			endTimestamp.setTime(endTimestamp.getTime() + 21600000);
			Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
			if (currentTimestamp.after(endTimestamp)) {
				outdated.add(row);
			}
		}
		
		for (Map<String, Object> delete : outdated) {
			rep.deleteListedParking(((BigInteger) delete.get("id")).longValue());
		}
		
		return rep.getUserListedParking(userID);
	}
}
