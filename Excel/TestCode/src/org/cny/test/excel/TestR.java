package org.cny.test.excel;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.Test;

import java.io.FileInputStream;

/**
 * Created by cny on 7/11/14.
 */
public class TestR {

    @Test
    public void testRead() throws Exception {
        FileInputStream fis = new FileInputStream("data/a.xlsm");
        Workbook wb = new XSSFWorkbook(fis);
        Sheet sheet = wb.getSheetAt(0);
        FormulaEvaluator evaluator = wb.getCreationHelper().createFormulaEvaluator();

// suppose your formula is in B3
        CellReference cellReference = new CellReference("A1");
        Row row = sheet.getRow(cellReference.getRow());
        Cell cell = row.getCell(cellReference.getCol());

        CellValue cellValue = evaluator.evaluate(cell);

        switch (cellValue.getCellType()) {
            case Cell.CELL_TYPE_BOOLEAN:
                System.out.println(cellValue.getBooleanValue());
                break;
            case Cell.CELL_TYPE_NUMERIC:
                System.out.println("CELL_TYPE_NUMERIC");
                System.out.println(cellValue.getNumberValue());
                break;
            case Cell.CELL_TYPE_STRING:
                System.out.println("CELL_TYPE_STRING");
                System.out.println(cellValue.getStringValue());
                break;
            case Cell.CELL_TYPE_BLANK:
                break;
            case Cell.CELL_TYPE_ERROR:
                break;

            // CELL_TYPE_FORMULA will never happen
            case Cell.CELL_TYPE_FORMULA:
                break;
        }
    }
}
