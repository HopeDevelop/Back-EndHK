package model;

import java.util.ArrayList;

import org.json.JSONObject;

public class Donation {
	private String description;
	private String type;
	private String link;
	private ArrayList<String> flags;
	private String title;
	public Donation(String title,String description,String type){
		this.setTitle(title);
		this.setDescription(description);
		this.setType(type);
		this.flags = new ArrayList<String>();
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public ArrayList<String> getFlags() {
		return flags;
	}
	public void setFlags(ArrayList<String> flags) {
		this.flags = flags;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public JSONObject createJSON(){
		JSONObject json = new JSONObject();
		json.put("title",this.getTitle());
		json.put("link", this.getLink());
		json.put("description",this.getDescription());
		json.put("type", this.getType());
		json.put("flags", this.getFlags());
		return json;
	}
}
