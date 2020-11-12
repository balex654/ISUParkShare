package com.parkshare.backend.dao;

import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.parkshare.backend.models.ListedParking;

@Repository
public interface ListedParkingRepo extends JpaRepository<ListedParking, Long> {
	
	@Query(value = "select lp.id, pa.id as area_id, pa.address, pa.num_spots, lp.spot_taken, lp.start_time, lp.end_time from \n" + 
			"ParkingArea pa inner join ListedParking lp on pa.id = lp.area_id where pa.user_id = :userID", nativeQuery = true)
	List<Map<String, Object>> getUserListedParking(@Param("userID") Long userID);
	
	@Query(value = "select lp.id, pa.address, pa.num_spots, lp.spot_taken, lp.start_time, lp.end_time, pa.price_per_spot, pa.notes, u.username, u.venmo_username from\n" + 
			"ParkingArea pa inner join ListedParking lp on pa.id = lp.area_id inner join User u on pa.user_id = u.id where u.id != :userID", nativeQuery = true)
	List<Map<String, Object>> getAllListedParking(@Param("userID") Long userID);
	
	@Transactional
	@Modifying
	@Query(value = "delete from ListedParking where id = :id", nativeQuery = true)
	void deleteListedParking(@Param("id") Long id);
	
	@Transactional
	@Modifying
	@Query(value = "update ListedParking set spot_taken = spot_taken + :spotsTaken where id = :id", nativeQuery = true)
	void updateNumSpots(@Param("id") Long id, @Param("spotsTaken") Integer spotsTaken);
	
	@Query(value = "select v.make, v.model, v.plate_number, v.color, u.username from \n" + 
			"UserVehicles v inner join VehicleRentedArea vra on v.id = vra.vehicle_id\n" + 
			"inner join User u on u.id = v.user_id where vra.listed_area_id = :listedAreaId", nativeQuery = true)
	List<Map<String, Object>> getVehiclesInArea(@Param("listedAreaId") Long listedAreaId);
}
