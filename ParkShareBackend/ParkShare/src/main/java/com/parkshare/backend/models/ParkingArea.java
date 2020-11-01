package com.parkshare.backend.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name="ParkingArea")
public class ParkingArea {

	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="area_seq")
	@SequenceGenerator(name="area_seq", sequenceName="area_seq", initialValue=1, allocationSize=1)
	@Column(name="id")
	private long id;
	
	@Column(name="user_id")
	private long user_id;
	
	@Column(name="address")
	private String address;
	
	@Column(name="num_spots")
	private int num_spots;
	
	@Column(name="price_per_spot")
	private double price_per_spot;
	
	@Column(name="notes")
	private String notes;

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

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getNum_spots() {
		return num_spots;
	}

	public void setNum_spots(int num_spots) {
		this.num_spots = num_spots;
	}

	public double getPrice_per_spot() {
		return price_per_spot;
	}

	public void setPrice_per_spot(double price_per_spot) {
		this.price_per_spot = price_per_spot;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	@Override
	public String toString() {
		return "ParkingArea [id=" + id + ", user_id=" + user_id + ", address=" + address + ", num_spots=" + num_spots
				+ ", price_per_spot=" + price_per_spot + ", notes=" + notes + "]";
	}
	
}
