package model;

import java.io.FileWriter;
import java.io.IOException;

import org.json.*;

public class Main {

	public static void main(String[] args) {
		Donator dn = new Donator("user","email","password"); 
		dn.getFavorites().add("Teste");
		JSONObject json = dn.createJSON();
		
		try (FileWriter file = new FileWriter("/home/bruno/workspace/JSON-HopeDev/jsonex")) {

            file.write(json.toString());
            file.flush();

        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.print(json);
		

	}

}
