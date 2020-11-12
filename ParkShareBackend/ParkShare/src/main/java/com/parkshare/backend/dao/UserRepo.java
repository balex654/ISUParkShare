package com.parkshare.backend.dao;

import java.util.List;
import java.util.Map;

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
	
	@Query(value = "select distinct address, pa.num_spots, lp.spot_taken, lp.start_time, lp.end_time, pa.price_per_spot, u.username, u.venmo_username, pa.notes from \n" + 
			"ListedParking lp inner join VehicleRentedArea vra on lp.id = vra.listed_area_id\n" + 
			"inner join ParkingArea pa on lp.area_id = pa.id \n" + 
			"inner join UserVehicles v on v.id = vra.vehicle_id\n" + 
			"inner join User u on u.id = pa.user_id\n" + 
			"where v.user_id = :userID", nativeQuery = true)
	List<Map<String, Object>> getRentedAreas(@Param("userID") Long userID);
}