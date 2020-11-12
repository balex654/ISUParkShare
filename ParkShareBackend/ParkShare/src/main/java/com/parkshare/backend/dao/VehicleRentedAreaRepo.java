package com.parkshare.backend.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.parkshare.backend.models.VehicleRentedArea;

@Repository
public interface VehicleRentedAreaRepo extends JpaRepository<VehicleRentedArea, Long> {
	
}
