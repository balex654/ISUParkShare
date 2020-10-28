package com.parkshare.backend.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.parkshare.backend.models.UserVehicles;

@Repository
public interface UserVehiclesRepo extends JpaRepository<UserVehicles, Long> {
	
	@Query(value = "select * from UserVehicles where user_id = :userID", nativeQuery = true)
	List<UserVehicles> getUserVehicles(@Param("userID") Long userID);
	
	@Transactional
	@Modifying
	@Query(value = "delete from UserVehicles where id = :id", nativeQuery = true)
	void removeVehicle(@Param("id") Long id);
}
