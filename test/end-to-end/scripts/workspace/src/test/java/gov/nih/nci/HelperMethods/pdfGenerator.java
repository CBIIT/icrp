package gov.nih.nci.HelperMethods;


import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.ExceptionConverter;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.GrayColor;
import com.itextpdf.text.pdf.PdfAction;
import com.itextpdf.text.pdf.PdfBorderDictionary;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfFormField;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPCellEvent;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfTemplate;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.TextField;


public class pdfGenerator {
	public PdfPTable bTable;
	public Document document = new Document(PageSize.A4, 36, 36, 78, 36);;
	public PdfPCell resultCell;
	public PdfPTable hTable = new PdfPTable(2);
	public static final Font Hyperlink = new Font(FontFamily.UNDEFINED, 10, Font.UNDERLINE);
	public Image image;
	public int snapShotCount=0;
		
	class TableHeader extends PdfPageEventHelper {
        /** The header text. */
        String header;
        /** The template with the total number of pages. */
        PdfTemplate total;
 
        /**
         * Allows us to change the content of the header.
         * @param header The new header String
         */
        public void setHeader(String header) {
            this.header = header;
        }
 
        /**
         * Creates the PdfTemplate that will hold the total number of pages.
         * @see com.itextpdf.text.pdf.PdfPageEventHelper#onOpenDocument(
         *      com.itextpdf.text.pdf.PdfWriter, com.itextpdf.text.Document)
         */
        public void onOpenDocument(PdfWriter writer, Document document) {
            total = writer.getDirectContent().createTemplate(30, 16);
        }
 
        /**
         * Adds a header to every page
         * @see com.itextpdf.text.pdf.PdfPageEventHelper#onEndPage(
         *      com.itextpdf.text.pdf.PdfWriter, com.itextpdf.text.Document)
         */
        public void onEndPage(PdfWriter writer, Document document) {
            PdfPTable table = new PdfPTable(4);
            try {
                table.setWidths(new int[]{4, 10, 5,4});
                table.setTotalWidth(650);
                table.setLockedWidth(true);
                table.getDefaultCell().setFixedHeight(20);
                table.getDefaultCell().setBorder(Rectangle.BOTTOM);
    		    String imgfilePath = new File("").getAbsolutePath().toString();
    		    String rplcimgFilePath = imgfilePath.replace("\\", "//");
    		    String gBuildPath = ""+rplcimgFilePath+"//AppConf//img//Leidos.png";
    		    //System.out.println("image["+gBuildPath);
    		    Image logo = Image.getInstance(gBuildPath);
                table.addCell(logo);
                table.addCell(header);
                table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(String.format("Page %d of", writer.getPageNumber()));
                PdfPCell cell = new PdfPCell(Image.getInstance(total));
                cell.setBorder(Rectangle.BOTTOM);
                table.addCell(cell);
                table.writeSelectedRows(0, -1, 34, 803, writer.getDirectContent());
            }
            catch(DocumentException de) {
                throw new ExceptionConverter(de);
            } catch (MalformedURLException e) {
				// TODO Auto-generated catch block
            	System.out.println(e.getMessage());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.out.println(e.getMessage());
			}
        }
 
        /**
         * Fills out the total number of pages before the document is closed.
         * @see com.itextpdf.text.pdf.PdfPageEventHelper#onCloseDocument(
         *      com.itextpdf.text.pdf.PdfWriter, com.itextpdf.text.Document)
         */
        public void onCloseDocument(PdfWriter writer, Document document) {
            ColumnText.showTextAligned(total, Element.ALIGN_LEFT,
                    new Phrase(String.valueOf(writer.getPageNumber() - 1)),
                    2, 2, 0);
        }
    }
	public PdfPTable createHeaderTable(String sTestID, String sTestDesc, String sURL, String sBrowser, String sAuthor, String sDate) throws DocumentException{
		// header table with two columns
		
		hTable.setWidths(new int[]{10,30});
		hTable.setHorizontalAlignment(0);
		hTable.getDefaultCell().setBackgroundColor(BaseColor.LIGHT_GRAY);
		hTable.addCell("Release");
		hTable.addCell(sTestID);
		
		hTable.addCell("Release Description");

		hTable.addCell(sTestDesc);
		
		hTable.addCell("Env");
		hTable.addCell(sURL);
		
		hTable.addCell("Browser");
		hTable.addCell(sBrowser);
		
		hTable.addCell("Author");
		hTable.addCell(sAuthor);
		
		hTable.addCell("Test Date");
		hTable.addCell(sDate);
		
		hTable.addCell("Test Result");
		resultCell = new PdfPCell();
		resultCell.setBackgroundColor(BaseColor.LIGHT_GRAY);
		resultCell.setCellEvent(new TextFields(1));
		hTable.addCell(resultCell);
		
		return hTable;
	}
	public void createBlockTableHeader(PdfPTable bTable) throws DocumentException{
//		bTable = new PdfPTable(5);
		bTable.setWidths(new int[]{5,15,10,15,5});
		bTable.setHorizontalAlignment(0);
		bTable.getDefaultCell().setBackgroundColor(BaseColor.LIGHT_GRAY);
		bTable.addCell("Function Call #");
		bTable.addCell("Function Name");
		bTable.addCell("Function Description");
		bTable.addCell("Remarks");
		bTable.addCell("Status");
		bTable.getDefaultCell().setBackgroundColor(null);
		
//		return bTable;
	}
	
	public void createBlockHeader(String sBlock, String sTestDescription) throws DocumentException{
		document.add(new Paragraph(" "));
		document.add(new Paragraph("Test: " + sBlock));
		document.add(new Paragraph("Test Description: " + sTestDescription));
		document.add(new Paragraph(" "));
	}
	
	public void enterBlockSteps(PdfPTable bTable, int stepCount,String keyword, String stepDesc, String testData,String result){
		String sCount = Integer.toString(stepCount);
		bTable.addCell(sCount);

		bTable.addCell(stepDesc);
		bTable.addCell(keyword);
		bTable.addCell(testData);
		if (result.equals("Pass")){
			bTable.getDefaultCell().setBackgroundColor(BaseColor.GREEN);
			bTable.addCell(result);
		}
		else{
			bTable.getDefaultCell().setBackgroundColor(BaseColor.RED);
			bTable.addCell(result);
		}
		bTable.getDefaultCell().setBackgroundColor(null);
	}
	
	public void enterBlockSteps(PdfPTable bTable, int stepCount, String keyword, String stepDesc,  String testData,String result,String gBookmark){
		String sCount = Integer.toString(stepCount);
		bTable.addCell(sCount);
		Paragraph p = new Paragraph("");
		Hyperlink.setColor(BaseColor.BLUE);
		Chunk toBookmark = new Chunk(stepDesc,Hyperlink);
        toBookmark.setAction(PdfAction.gotoLocalPage(gBookmark, false));
       // System.out.println("Bookmark name is: "+ gBookmark);
        p.add(toBookmark);

		bTable.addCell(p);
		bTable.addCell(keyword);
		bTable.addCell(testData);
		if (result.equals("Pass")){
			bTable.getDefaultCell().setBackgroundColor(BaseColor.GREEN);
			bTable.addCell(result);
		}
		else{
			bTable.getDefaultCell().setBackgroundColor(BaseColor.RED);
			bTable.addCell(result);
		}
		bTable.getDefaultCell().setBackgroundColor(null);
	}

	public void createPDF (String filename) throws DocumentException, MalformedURLException, IOException{
		PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(filename));
		writer.setFullCompression();
//		writer.setCompressionLevel(0);
		TableHeader event = new TableHeader();
		event.setHeader("Selenium Automation Test Result");
		writer.setPageEvent(event);
		document.open();
	}
	public void savePDF() {

		document.close();
		
		
	}
	public void updateOverAllResult(String src, String dest, String status) throws DocumentException, FileNotFoundException, IOException{
	
		PdfReader reader = new PdfReader(src);
	    PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(dest));
	    AcroFields form = stamper.getAcroFields();
	    form.setField("text_1", status);
	    stamper.close();
	}
	
	public class TextFields implements PdfPCellEvent {
		 
	    protected int tf;
	 
	    /**
	     * Creates a cell event that will add a text field to a cell.
	     * @param tf a text field index.
	     */
	    public TextFields(int tf) {
	        this.tf = tf;
	    }
	 
	    /**
	     * Creates and adds a text field that will be added to a cell.
	     * @see com.itextpdf.text.pdf.PdfPCellEvent#cellLayout(com.itextpdf.text.pdf.PdfPCell,
	     *      com.itextpdf.text.Rectangle, com.itextpdf.text.pdf.PdfContentByte[])
	     */
	    public void cellLayout(PdfPCell cell, Rectangle rectangle, PdfContentByte[] canvases) {
	        PdfWriter writer = canvases[0].getPdfWriter();
	        TextField text = new TextField(writer, rectangle,
	                String.format("text_%s", tf));
	        text.setBackgroundColor(new GrayColor(0.75f));
	        switch(tf) {
	        case 1:
	            text.setBorderStyle(PdfBorderDictionary.STYLE_DASHED);
	            text.setText("Update your Test result");
	            text.setFontSize(0);
	            text.setAlignment(Element.ALIGN_LEFT);
//	            text.setOptions(TextField.REQUIRED);
	            break;
	        }
	        try {
	            PdfFormField field = text.getTextField();
	            writer.addAnnotation(field);
	        }
	        catch(IOException ioe) {
	            throw new ExceptionConverter(ioe);
	        }
	        catch(DocumentException de) {
	            throw new ExceptionConverter(de);
	        }
	    }
	 
	}
	
	public void deleteTempResult(String filePath){
		File f = new File (filePath);
		f.delete();
	}
	
	public void saveImageFiles(File dir) throws MalformedURLException, IOException, DocumentException{
		
		//String path = System.getProperty("user.dir")+"//src//Results//snapshots//"; 
		String path = dir + "//snapshots//";
		 
		  String files;
		  File folder = new File(path);
		  File[] listOfFiles = folder.listFiles(); 
		  snapShotCount=0;
		  for (int i = 0; i < listOfFiles.length; i++) 
		  {
		 
		   if (listOfFiles[i].isFile()) 
		   {
		   files = listOfFiles[i].getName();
		       if (files.endsWith(".png") || files.endsWith(".PNG"))
		       {
		    	   snapShotCount++;
		    	   image = Image.getInstance(path+files);
		    	   image.setCompressionLevel(0);
				   image.scalePercent(20);

					document.newPage();
					Chunk gBookmark = new Chunk(" ");
			        gBookmark.setLocalDestination(files);
			       // System.out.println("Bookmark set is: Bookmark"+files);
			        document.add(gBookmark);
			        document.add(image);
		        }
		     }
		  }
		deleteSnapShots(dir);
	}
	public void deleteSnapShots(File dir){
		File directory = new File(dir + "//snapshots//");
		File[] files = directory.listFiles();
		for (File file : files)
		{
		   // Delete each file

		   if (!file.delete())
		   {
		       // Failed to delete file

		       System.out.println("Failed to delete "+file);
		   }
		}
	}
	


}

