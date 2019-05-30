@isTest
private class PointOfSalesConnection_Test {
	    @isTest
    static void posConnection_Test(){
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new PosHttpsMock());     
        DataSource.ConnectionParams conectParams = new DataSource.ConnectionParams();
        PointOfSalesConnection PosConnector = new PointOfSalesConnection(conectParams);   
        List<DataSource.Table> tables = PosConnector.sync();
        //SearchContext(metadata, offset, maxResults, tableSelections, searchPhrase)
        DataSource.TableSelection tableSelection = new DataSource.TableSelection();
        tableSelection.tableSelected = 'POSProductsList__x';
        //tables,1, 5,tableSelection,'SELECT item_name__c FROM POSProductsList__x'
        List<DataSource.TableSelection> tableSelectionList = new List<DataSource.TableSelection>();
        tableSelectionList.add(tableSelection);
        DataSource.SearchContext context = new DataSource.SearchContext();
        context.metadata = tables;
        context.offset = 1;
        context.maxResults = 5;
        context.tableSelections = tableSelectionList;
        context.searchPhrase = 'MFTA';
        List<DataSource.TableResult> results = PosConnector.search(context);   
        
        Test.stopTest();
    }
}