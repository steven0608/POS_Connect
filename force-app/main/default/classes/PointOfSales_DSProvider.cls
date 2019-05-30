global class PointOfSales_DSProvider extends DataSource.Provider{
    
    // Define the supported Authentication capability, in this case, i used Anonymous
    // 
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        List<DataSource.AuthenticationCapability> capabilities =  new List<DataSource.AuthenticationCapability>();
        capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
        return capabilities;
    }
    
    // in this case, we enable the Qow query and search capability
    
    override global List<DataSource.Capability> getCapabilities()
    {
        List<DataSource.Capability> capabilities = new
            List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.ROW_QUERY);
        capabilities.add(DataSource.Capability.SEARCH); 
        //Below Capabilities are not supported in this example
        //We used can extend the below capability if we created more methods to support it
        //capabilities.add(DataSource.Capability.ROW_CREATE);
        //capabilities.add(DataSource.Capability.ROW_UPDATE);
        //capabilities.add(DataSource.Capability.ROW_DELETE);
        return capabilities;
    }
    
    // now we can connect the external sources
    override global DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams) {   
        return new PointOfSalesConnection(connectionParams);
    } 
}