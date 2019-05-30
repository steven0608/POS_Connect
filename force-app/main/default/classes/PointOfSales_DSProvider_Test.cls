@isTest
private class PointOfSales_DSProvider_Test {
    @isTest
    static void posProviderTest() {
        Test.startTest();     
        
        PointOfSales_DSProvider PosConnection = new PointOfSales_DSProvider();
        PosConnection.getAuthenticationCapabilities();
        PosConnection.getCapabilities();
        //DataSource.ConnectionParams conectParams = new DataSource.ConnectionParams();
        //DataSource.Connection PosConnector = PosConnection.getConnection(conectParams);
        
        Test.stopTest();
    }
}