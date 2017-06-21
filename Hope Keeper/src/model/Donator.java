package model;

import java.util.ArrayList;

import org.json.JSONObject;

public class Donator extends User{
	private ArrayList<String> favorites;
	public Donator(String username,String password,String email){
		super.setUsername(username);
		super.setPassword(password);
		super.setEmail(email);
		this.favorites = new ArrayList<String>();
	}
	public JSONObject createJSON(){
		JSONObject json = new JSONObject();
		json.put("email",this.getEmail());
		json.put("password", this.getPassword());
		json.put("username",this.getUsername());
		json.put("favorites", this.getFavorites());
		return json;
	}
	public ArrayList<String> getFavorites() {
		return favorites;
	}
	public void setFavorites(ArrayList<String> favorites) {
		this.favorites = favorites;
	}

}
