package com.parkshare.backend.dao;

import java.util.List;
import java.util.Map;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.parkshare.backend.models.ListedParking;

@Repository
public interface ListedParkingRepo extends JpaRepository<ListedParking, Long> {
	
	@Query(value = "select lp.id, pa.address, pa.num_spots, lp.spot_taken, lp.start_time, lp.end_time from \n" + 
			"ParkingArea pa inner join ListedParking lp on pa.id = lp.area_id where pa.user_id = :userID", nativeQuery = true)
	List<Map<String, Object>> getUserListedParking(@Param("userID") Long userID);
	
}
