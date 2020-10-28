package com.parkshare.backend.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name="UserVehicles")
public class UserVehicles {
	
	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="user_vehicle_seq")
	@SequenceGenerator(name="user_vehicle_seq", sequenceName="user_vehicle_seq", initialValue=1, allocationSize=1)
	@Column(name="id")
	private long id;
	
	@Column(name="user_id")
	private long user_id;
	
	@Column(name="make")
	private String make;
	
	@Column(name="model")
	private String model;
	
	@Column(name="color")
	private String color;
	
	@Column(name="plate_number")
	private String plate_number;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getUser_id() {
		return user_id;
	}

	public void setUser_id(long user_id) {
		this.user_id = user_id;
	}

	public String getMake() {
		return make;
	}

	public void setMake(String make) {
		this.make = make;
	}

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getPlate_number() {
		return plate_number;
	}

	public void setPlate_number(String plate_number) {
		this.plate_number = plate_number;
	}

	@Override
	public String toString() {
		return "UserVehicles [id=" + id + ", user_id=" + user_id + ", make=" + make + ", model=" + model + ", color="
				+ color + ", plate_number=" + plate_number + "]";
	}
}
