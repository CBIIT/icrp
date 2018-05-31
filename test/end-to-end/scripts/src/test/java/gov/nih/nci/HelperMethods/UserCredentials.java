		package gov.nih.nci.HelperMethods;
		
		import java.io.*;
		import java.io.FileReader;
		import java.io.IOException;
		 	
		
		public class UserCredentials {

			public static void main(String [] args) {
				 /*	
		         / The name of the credential file to open.
		        */
		        String fileName = "C://My_Frameworks_creds//UserCred//Applications//caNanoLab//uCred.txt";
					
				 /*	
		         / This will reference one line at a time
		        */
		        String line = null;

		        try {
		        	/*	
			         / FileReader reads text files in the default encoding.
			        */
		            FileReader fileReader = new FileReader(fileName);
		        	/*	
			         / Always wrap FileReader in BufferedReader.
			        */
		            BufferedReader bufferedReader = new BufferedReader(fileReader);

		            while((line = bufferedReader.readLine()) != null) {
		                System.out.println(line);
			            /*String string = line;
    	                
		                if (string.contains(",")) {
		                    // Split it.
		                	String[] parts = string.split(",");
			                String part1 = parts[0];
			                String part2 = parts[1];
			                String part3 = parts[2];
			                String part4 = parts[3];
		                } else {
		                    throw new IllegalArgumentException("String " + string + " does not contain ,");
		                }*/		            
		            }	
		            bufferedReader.close();			
		        }
		        catch(FileNotFoundException ex) {
		            System.out.println(
		                "Unable to open file '" + 
		                fileName + "'");				
		        }
		        catch(IOException ex) {
		            System.out.println(
		                "Error reading file '" 
		                + fileName + "'");					
		            // Or we could just do this: 
		            // ex.printStackTrace();
		        }
		    }
		}
		