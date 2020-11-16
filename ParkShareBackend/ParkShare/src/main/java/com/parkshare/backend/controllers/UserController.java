package com.parkshare.backend.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.parkshare.backend.dao.UserRepo;
import com.parkshare.backend.models.User;
import com.sendgrid.Content;
import com.sendgrid.Email;
import com.sendgrid.Mail;
import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.SendGrid;

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
	
	@RequestMapping(method = RequestMethod.GET, path = "/sendEmail/{email}")
	public Map<String, Object> sendEmail(@PathVariable("email") String email) throws IOException {
		Map<String, Object> result = new HashMap<String, Object>();
		
		// Check if account with the email exists
		User u = rep.findByEmail(email);
		if (u == null) {
			result.put("userID", -1);
			return result;
		}
		result.put("userID", u.getId());
		
		// Create code
		Random rand = new Random();
		int upperbound = 10;
		int first = rand.nextInt(upperbound);
		int second = rand.nextInt(upperbound);
		int third = rand.nextInt(upperbound);
		int fourth = rand.nextInt(upperbound);
		int fifth = rand.nextInt(upperbound);
		int sixth = rand.nextInt(upperbound);
		String code = "" + first + second + third + fourth + fifth + sixth;
		result.put("code", code);

		// Send email
		Email from = new Email("isuparkshare@gmail.com");
		String subject = "ISU Park Share Password Verification Code";
		Email to = new Email(email);
		Content content = new Content("text/plain", "Your code is " + code);
		Mail mail = new Mail(from, subject, to, content);

		SendGrid sg = new SendGrid("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");
		Request request = new Request();
		try {
			request.setMethod(Method.POST);
			request.setEndpoint("mail/send");
			request.setBody(mail.build());
			sg.api(request);

			return result;
		} catch (IOException ex) {
			throw ex;
		}
	}
	
	@RequestMapping(method = RequestMethod.PUT, path = "/modifyPassword/{user_id}/{password}")
	public void modifyPassword(@PathVariable("user_id") long user_id, @PathVariable("password") String pw) {

		User oldUser = rep.findByUserID(user_id);

		String encrypted = BCrypt.hashpw(pw, BCrypt.gensalt());
		oldUser.setPassword(encrypted);

		rep.save(oldUser);
	}
	
}