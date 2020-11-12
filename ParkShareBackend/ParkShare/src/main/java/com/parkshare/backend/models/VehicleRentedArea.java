package com.parkshare.backend.models;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

@Entity
@Table(name="VehicleRentedArea")
@IdClass(VehicleRentedArea.class)
public class VehicleRentedArea implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="vehicle_id")
	private long vehicle_id;
	
	@Id
	@Column(name="listed_area_id")
	private long listed_area_id;
	
	public VehicleRentedArea() {}
	
	public VehicleRentedArea(long vehicleId, long listedAreaId) {
		this.vehicle_id = vehicleId;
		this.listed_area_id = listedAreaId;
	}

	public long getVehicle_id() {
		return vehicle_id;
	}

	public void setVehicle_id(long vehicle_id) {
		this.vehicle_id = vehicle_id;
	}

	public long getListed_area_id() {
		return listed_area_id;
	}

	public void setListed_area_id(long listed_area_id) {
		this.listed_area_id = listed_area_id;
	}

	@Override
	public String toString() {
		return "VehicleRentedArea [vehicle_id=" + vehicle_id + ", listed_area_id=" + listed_area_id + "]";
	}
	
}
