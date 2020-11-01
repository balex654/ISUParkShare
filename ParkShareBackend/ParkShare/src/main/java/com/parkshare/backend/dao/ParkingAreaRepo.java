package com.parkshare.backend.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.parkshare.backend.models.ParkingArea;

@Repository
public interface ParkingAreaRepo extends JpaRepository<ParkingArea, Long> {
	
	@Query(value = "select * from ParkingArea where user_id = :userID", nativeQuery = true)
	List<ParkingArea> getParkingAreas(@Param("userID") Long userID);
	
	@Modifying
	@Transactional
	@Query(value = "delete from ParkingArea where id = :id", nativeQuery = true)
	void removeParkingArea(@Param("id") Long id);
}
