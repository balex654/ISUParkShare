package com.parkshare.backend.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.parkshare.backend.models.User;

@Repository
public interface UserRepo extends JpaRepository<User, Long> {
	
	@Query(value = "select * from User where email = :email", nativeQuery = true)
	User findByEmail(@Param("email") String email);
	
	@Query(value = "select * from User where username = :username", nativeQuery = true)
	User findByUsername(@Param("username") String username);
	
	@Query(value = "select * from User where venmo_username = :venmo", nativeQuery = true)
	User findByVenmo(@Param("venmo") String venmo);
}
