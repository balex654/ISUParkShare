package com.parkshare.backend.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name="ListedParking")
public class ListedParking {
	
	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="listed_seq")
	@SequenceGenerator(name="listed_seq", sequenceName="listed_seq", initialValue=1, allocationSize=1)
	@Column(name="id")
	private long id;
	
	@Column(name="area_id")
	private long area_id;
	
	@Column(name="user_id")
	private long user_id;
	
	@Column(name="start_time")
	private String start_time;
	
	@Column(name="end_time")
	private String end_time;
	
	@Column(name="spot_taken")
	private int spot_taken;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getArea_id() {
		return area_id;
	}

	public void setArea_id(long area_id) {
		this.area_id = area_id;
	}

	public long getUser_id() {
		return user_id;
	}

	public void setUser_id(long user_id) {
		this.user_id = user_id;
	}

	public String getStart_time() {
		return start_time;
	}

	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}

	public String getEnd_time() {
		return end_time;
	}

	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}

	public int getSpot_taken() {
		return spot_taken;
	}

	public void setSpot_taken(int spot_taken) {
		this.spot_taken = spot_taken;
	}

	@Override
	public String toString() {
		return "ListedParking [id=" + id + ", area_id=" + area_id + ", user_id=" + user_id + ", start_time="
				+ start_time + ", end_time=" + end_time + ", spot_taken=" + spot_taken + "]";
	}
	
}
