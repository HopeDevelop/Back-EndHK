package model;

import java.util.ArrayList;
import java.util.Date;

import org.json.JSONObject;

public class Event {
	private String title;
	
	private String place;
	private String time;
	private ArrayList<String> flags;
	private Date date;
	public Event(String title,String place,String time,ArrayList<String> flags,Date date){
		this.place = place;
		this.time = time;
		this.flags = flags;
		this.date = date;
		this.title = title;
	}
	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public ArrayList<String> getFlags() {
		return flags;
	}
	public void setFlags(ArrayList<String> flags) {
		this.flags = flags;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public JSONObject createJSON(){
		JSONObject json = new JSONObject();
		json.put("title",this.getTitle());
		json.put("place",this.place);
		json.put("time",this.time);
		json.put("date",this.date);
		json.put("flags", this.flags);
		return json;
	}
}
