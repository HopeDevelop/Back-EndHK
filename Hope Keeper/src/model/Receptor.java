package model;

import java.util.ArrayList;

import org.json.JSONObject;

public class Receptor extends User{
	private String adress;
	private ArrayList<String> phoneNumber;
	private ArrayList<String> paymentOptons;
	private ArrayList<String> flags;
	private ArrayList<Donation> donation;
	private ArrayList<Event> event;
	private String cnpj;
	private String site;
 	
	public Receptor(String username,String password,String email){
		super.setUsername(username);
		super.setPassword(password);
		super.setEmail(email);
	}
	public String getAdress() {
		return adress;
	}
	public void setAdress(String adress) {
		this.adress = adress;
	}
	public ArrayList<String> getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(ArrayList<String> phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public ArrayList<String> getPaymentOptons() {
		return paymentOptons;
	}
	public void setPaymentOptons(ArrayList<String> paymentOptons) {
		this.paymentOptons = paymentOptons;
	}
	public ArrayList<String> getFlags() {
		return flags;
	}
	public void setFlags(ArrayList<String> flags) {
		this.flags = flags;
	}
	public ArrayList<Donation> getDonation() {
		return donation;
	}
	public void setDonation(ArrayList<Donation> donation) {
		this.donation = donation;
	}
	public ArrayList<Event> getEvent() {
		return event;
	}
	public void setEvent(ArrayList<Event> event) {
		this.event = event;
	}
	public String getCnpj() {
		return cnpj;
	}
	public void setCnpj(String cnpj) {
		this.cnpj = cnpj;
	}
	public String getSite() {
		return site;
	}
	public void setSite(String site) {
		this.site = site;
	}
	public JSONObject createJSON(){
		JSONObject json = new JSONObject();
		json.put("cnpg", this.getCnpj());
		json.put("site",this.getSite());
		json.put("email",this.getEmail());
		json.put("password", this.getPassword());
		json.put("username",this.getUsername());
		json.put("adress", this.getAdress());
		json.put("phoneNumber",this.getPhoneNumber());
		json.put("paymentOptions", this.getPaymentOptons());
		json.put("flags", this.getFlags());
		json.put("donation",this.getDonation());
		json.put("event", this.getEvent());
		return json;
	}

}
