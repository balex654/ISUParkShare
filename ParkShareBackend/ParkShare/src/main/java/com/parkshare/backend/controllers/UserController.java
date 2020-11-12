package com.parkshare.backend.controllers;

import java.util.List;
import java.util.Map;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.parkshare.backend.dao.UserRepo;
import com.parkshare.backend.models.User;

@RestController
public class UserController {
	
	@Autowired
	UserRepo rep;
	
	@RequestMapping(method = RequestMethod.POST, path = "/createUser")
	public long createUser(User user) {
		String encrypted = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
		user.setPassword(encrypted);
		
		rep.save(user);
		
		return user.getId();
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/checkUser/{email}/{password}")
	public User checkUser(@PathVariable("email") String email, @PathVariable("password") String pw) {
		User user = rep.findByEmail(email);
		if (user == null) {
			return null;
		}
		
		if (BCrypt.checkpw(pw, user.getPassword())) {
			user.setPassword("");
			return user;
		}
		else {
			return null;
		}
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/checkUniqueness/{username}/{email}/{venmo}")
	public String checkUniqueness(@PathVariable("username") String username, 
			@PathVariable("email") String email, @PathVariable("venmo") String venmo) {
		User user = rep.findByEmail(email);
		if (user != null) {
			return email;
		}
		
		user = rep.findByUsername(username);
		if (user != null) {
			return username;
		}
		
		user = rep.findByVenmo(venmo);
		if (user != null) {
			return venmo;
		}
		
		return null;
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/getRentedAreas/{userID}")
	public List<Map<String, Object>> getRentedAreas(@PathVariable("userID") long userID) {
		return rep.getRentedAreas(userID);
	}
	
}